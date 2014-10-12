SHELL = /bin/sh

APP_TITLE = CDVNewsstandDemo
PLUGIN_ID = org.pushandplay.cordova.newsstand

DIR	= .
DIR_SOURCES = $(DIR)/sources
DIR_SOURCES_SRC = $(DIR)/src
DIR_SOURCES_WWW = $(DIR_SOURCES)/www
DIR_STATIC = $(DIR_DEMO)/$(PLUGIN_ID)
DIR_STATIC_SRC = $(DIR_STATIC)/src
DIR_STATIC_WWW = $(DIR_STATIC)/www
DIR_DEMO = $(DIR)/demo
DIR_DEMO_APP = $(DIR_DEMO)/$(APP_TITLE)



.PHONY: all prepare coffee clean demo_create demo_update

all: prepare coffee clean
release: all compress
	@echo "\n\033[32mComplete\033[0m\n"


prepare:
	@echo "\n\033[32mPrepare $(DIR_BUILD) directory...\033[0m"
	@mkdir -p $(DIR_STATIC)
	@mkdir -p $(DIR_STATIC_WWW)
	@mkdir -p $(DIR_DEMO)
	@rsync -auz --partial $(DIR_SOURCES_SRC) $(DIR_STATIC)
	@cp $(DIR)/plugin.xml $(DIR_STATIC)


coffee:
	@echo "\033[32mCompile COFFEESCRIPT...\033[0m"
	@find $(DIR_SOURCES_WWW)/ -name '*.coffee' -exec coffee -o $(DIR_STATIC_WWW) -c -b {} \;
	@rsync -auz --partial $(DIR_STATIC_WWW) $(DIR)


clean:
	@echo "\033[32mClean $(DIR_BUILD) directory...\033[0m"
	@find $(DIR_STATIC)/ -type d -empty -delete


compress:
	@echo "\033[32mCompress files...\033[0m"
	@find $(DIR_BUILD) -name '*.js' -exec uglifyjs {} -o {} -c -m -d \;

demo_create: prepare
	@rm -rf $(DIR_DEMO_APP)
	@mkdir -p $(DIR_DEMO_APP)
	@cordova create $(DIR_DEMO_APP) $(PLUGIN_ID).$(APP_TITLE) $(APP_TITLE) --link-to=$(DIR_DEMO)/www/
	@cd $(DIR_DEMO_APP) && cordova platform add ios
	@cd $(DIR_DEMO_APP) && cordova plugins add ../$(PLUGIN_ID)
	@find $(DIR_DEMO_APP) -name "$(APP_TITLE).xcodeproj" -exec open {} \;

demo_update:
	@cd $(DIR_DEMO_APP) && cordova plugins remove $(PLUGIN_ID)
	@cd $(DIR_DEMO_APP) && cordova plugins add ../$(PLUGIN_ID)
	@cd $(DIR_DEMO_APP) && cordova prepare

demo_prepare: all
	@cd $(DIR_DEMO_APP) && cordova prepare