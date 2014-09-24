SHELL = /bin/sh

APP_TITLE = CordovaNewsstandDemoProject
PLUGIN_ID = org.pushandplay.cordova.newsstand

DIR	= .
DIR_SOURCES = $(DIR)/sources
DIR_SOURCES_SRC = $(DIR_SOURCES)/src
DIR_SOURCES_WWW = $(DIR_SOURCES)/www
DIR_STATIC = $(DIR)/$(PLUGIN_ID)
DIR_STATIC_SRC = $(DIR_STATIC)/src
DIR_STATIC_WWW = $(DIR_STATIC)/www
DIR_DEMO = $(DIR)/$(APP_TITLE)



.PHONY: all prepare coffee clean app_prepare

all: prepare coffee clean demo_update
release: all compress
	@echo "\n\033[32mComplete\033[0m\n"


prepare:
	@echo "\n\033[32mPrepare $(DIR_BUILD) directory...\033[0m"
	@mkdir -p $(DIR_STATIC)
	@mkdir -p $(DIR_STATIC_WWW)
	@rsync -auz --partial $(DIR_SOURCES_SRC) $(DIR_STATIC)
	@cp $(DIR_SOURCES)/plugin.xml $(DIR_STATIC)


coffee:
	@echo "\033[32mCompile COFFEESCRIPT...\033[0m"
	@find $(DIR_SOURCES_WWW)/ -name '*.coffee' -exec coffee -o $(DIR_STATIC_WWW) -c -b {} \;


clean:
	@echo "\033[32mClean $(DIR_BUILD) directory...\033[0m"
	@find $(DIR_STATIC)/ -type d -empty -delete


compress:
	@echo "\033[32mCompress files...\033[0m"
	@find $(DIR_BUILD) -name '*.js' -exec uglifyjs {} -o {} -c -m -d \;

demo_create:
	@rm -rf $(DIR_DEMO)
	@mkdir -p $(DIR_DEMO)
	@cordova create $(DIR_DEMO) $(PLUGIN_ID).$(APP_TITLE) $(APP_TITLE) --link-to=$(DIR_SOURCES)/app_www_test/
	@cd $(DIR_DEMO) && cordova platform add ios
	@cd $(DIR_DEMO) && cordova plugins add ../$(DIR_STATIC)

demo_update:
	@cd $(DIR_DEMO) && cordova plugins remove $(PLUGIN_ID)
	@cd $(DIR_DEMO) && cordova plugins add ../$(DIR_STATIC)
	@cd $(DIR_DEMO) && cordova prepare