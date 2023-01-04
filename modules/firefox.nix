# MacOS firefox configuration
{ pkgs
, lib
, inputs
, config
, ...
}: {
  programs.firefox = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then pkgs.firefox-bin else pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      add-custom-search-engine
      amp2html
      betterttv
      reddit-enhancement-suite
      tridactyl
      ublock-origin
      umatrix
    ];
  };

  programs.firefox.profiles =
    let
      userChrome = with config.lib.base16.theme; ''
        /*
         *  Hide window controls
         */
        .titlebar-buttonbox-container{
            display: none !important;
        }

        .titlebar-placeholder,
        #TabsToolbar .titlebar-spacer{ display: none; }
        #navigator-toolbox::after{ display: none !important; }


        /*
         *  Hide all the clutter in the navbar
         */
        #main-window :-moz-any(#back-button,
        		       #forward-button,
        		       #stop-reload-button,
        		       #home-button,
        		       #library-button,
        		       #sidebar-button,
        		       #star-button,
        		       #pocket-button,
        		       #permissions-granted-icon,
        		       #fxa-toolbar-menu-button,
        		       #_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action, /* Vimium */
        		       #ublock0_raymondhill_net-browser-action) { display: none !important; }

        /*
         *  Hide tabs if only one tab
         */
        #titlebar .tabbrowser-tab[first-visible-tab="true"][last-visible-tab="true"]{
            display: none !important;
        }

        /*
         *  Minimal theme
         */
        #navigator-toolbox {
            font-family: 'Menlo' !important;
        }

        #navigator-toolbox toolbarspring {
            display: none;
        }

        /* Hide filler */
        #customizableui-special-spring2{
        	display:none;
        }

        .tab-background{
        	padding-bottom: 0 !important;
        }

        #navigator-toolbox #urlbar-container {
            padding: 0 !important;
            margin: 0 !important;
        }

        #navigator-toolbox #urlbar {
            border: none !important;
            border-radius: 0 !important;
            box-shadow: none !important;
        }

        #navigator-toolbox #PanelUI-button {
            padding: 0 !important;
            margin: 0 !important;
            border: none !important;
        }

        #navigator-toolbox #nav-bar {
            box-shadow: none !important;
        }

        #navigator-toolbox #pageActionButton {
            display: none;
        }

        #navigator-toolbox #pageActionSeparator {
            display: none;
        }

        #fullscr-toggler {
            height: 0 !important;
        }

        #navigator-toolbox .urlbar-history-dropmarker {
            display: none;
        }

        #navigator-toolbox #tracking-protection-icon-container {
            padding-right: 0 !important;
            border: none !important;
            display: none !important;
        }

        #navigator-toolbox .tab-close-button, #navigator-toolbox #tabs-newtab-button {
            display: none;
        }

        #navigator-toolbox #urlbar {
            padding: 0 !important;
            padding-left: 1ch !important;
            font-size: 13px;
        }

        #navigator-toolbox #urlbar-background {
            border: none !important;
            margin: 0 !important;
        }

        #navigator-toolbox .toolbarbutton-1 {
            width: 22px;
        }

        #navigator-toolbox .tabbrowser-tab {
            font-size: 12px
        }

        #navigator-toolbox .tab-background {
            box-shadow: none!important;
            border: none !important;
        }

        #navigator-toolbox .tabbrowser-tab::after {
            display: none !important;
        }

        #navigator-toolbox #urlbar-zoom-button {
            border: none !important;
        }

        #appMenu-fxa-container, #appMenu-fxa-container + toolbarseparator {
            display: none !important;
        }

        #sync-setup {
            display: none !important;
        }

        /*
         *  Hamburger menu to the left
         */

        #PanelUI-button {
            -moz-box-ordinal-group: 0;
            border-left: none !important;
            border-right: none !important;
            position: absolute;
        }

        #toolbar-context-menu .viewCustomizeToolbar {
            display: none !important;
        }

        :root[uidensity=compact] #PanelUI-button {
            margin-top: -30px;
        }

        #PanelUI-button {
            margin-top: -30px;
        }

        :root[uidensity=touch] #PanelUI-button {
            margin-top: -36px;
        }

        /*
         *  Tabs to the right of the urlbar
         */

        /* Modify these to change relative widths or default height */
        #navigator-toolbox{
            --uc-navigationbar-width: 40vw;
            --uc-toolbar-height: 40px;
        }
        /* Override for other densities */
        :root[uidensity="compact"] #navigator-toolbox{ --uc-toolbar-height: 30px; }
        :root[uidensity="touch"] #navigator-toolbox{ --uc-toolbar-height: 40px; }

        :root[uidensity=compact] #urlbar-container.megabar{
            --urlbar-container-height: var(--uc-toolbar-height) !important;
            padding-block: 0 !important;
        }
        :root[uidensity=compact] #urlbar.megabar{
            --urlbar-toolbar-height: var(--uc-toolbar-height) !important;
        }

        /* prevent urlbar overflow on narrow windows */
        /* Dependent on how many items are in navigation toolbar ADJUST AS NEEDED */
        @media screen and (max-width: 1300px){
            #urlbar-container{ min-width:unset !important }
        }

        #TabsToolbar{ margin-left: var(--uc-navigationbar-width); }
        #tabbrowser-tabs{ --tab-min-height: var(--uc-toolbar-height) !important; }

        /* This isn't useful when tabs start in the middle of the window */
        .titlebar-placeholder[type="pre-tabs"],
        .titlebar-spacer[type="pre-tabs"]{ display: none }

        #navigator-toolbox > #nav-bar{
            margin-right:calc(100vw - var(--uc-navigationbar-width));
            margin-top: calc(0px - var(--uc-toolbar-height));
        }

        /* Zero window drag space  */
        :root[tabsintitlebar="true"] #nav-bar{ padding-left: 0px !important; padding-right: 0px !important; }

        /* 1px margin on touch density causes tabs to be too high */
        .tab-close-button{ margin-top: 0 !important }

        /* Hide dropdown placeholder */
        #urlbar-container:not(:hover) .urlbar-history-dropmarker{ margin-inline-start: -30px; }

        /* Fix customization view */
        #customization-panelWrapper > .panel-arrowbox > .panel-arrow{ margin-inline-end: initial !important; }
      '';
      settings = {
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.newtabpage.enabled" = false;
        "browser.bookmarks.showMobileBookmarks" = true;
        "browser.uidensity" = 1;
        "browser.urlbar.update1" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.socialtracking.annotate.enabled" = true;
        "services.sync.declinedEngines" = "addons,prefs";
        "services.sync.engine.addons" = false;
        "services.sync.engineStatusChanged.addons" = true;
        "services.sync.engine.prefs" = false;
        "services.sync.engineStatusChanged.prefs" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "gfx.webrender.all" = true;
        "general.smoothScroll" = true;
      };
    in
    {
      home = {
        inherit settings;
        inherit userChrome;
        id = 0;
      };
    };
}
