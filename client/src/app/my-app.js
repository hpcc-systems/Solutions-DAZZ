import { PolymerElement, html } from '@polymer/polymer/polymer-element';
import { setPassiveTouchGestures, setRootPath } from '@polymer/polymer/lib/utils/settings';
import '@polymer/app-layout/app-drawer/app-drawer';
import '@polymer/app-layout/app-drawer-layout/app-drawer-layout';
import '@polymer/app-layout/app-header/app-header';
import '@polymer/app-layout/app-header-layout/app-header-layout';
import '@polymer/app-layout/app-scroll-effects/app-scroll-effects';
import '@polymer/app-layout/app-toolbar/app-toolbar';
import '@polymer/app-route/app-location';
import '@polymer/app-route/app-route';
import '@polymer/iron-pages';
import '@polymer/iron-selector/iron-selector';
import '@polymer/paper-icon-button';
import '@polymer/paper-dropdown-menu/paper-dropdown-menu';
import '@vaadin/vaadin-dropdown-menu';
import {Comm} from  '../js/Comm.js';
import {Properties} from '../js/Properties.js';



import '../icons/my-icons.js';

setPassiveTouchGestures(true);

setRootPath(MyAppGlobals.rootPath);

class MyApp extends PolymerElement {



  static get template() {
    return html`
      <style>
        :host {
          --app-primary-color: #4285f4;
          --app-secondary-color: black;

          display: block;
        }

        app-drawer-layout:not([narrow]) [drawer-toggle] {
          display: none;
          
        }

        app-drawer {
          --app-drawer-content-container: {
            
            background-color: #404040;
          }
          --app-drawer-scrim-background: rgba(179, 157, 219, 0.5);
        }
        
        app-drawer-layout {
          background-color: lightgray;
        }

        app-header {
          color: #fff;
          background-color: var(--app-primary-color);
        }

        app-header paper-icon-button {
          --paper-icon-button-ink-color: white;
        }

        .drawer-list {
          margin: 0 20px;
          
        }

        .drawer-list a {
          display: block;
          padding: 0 16px;
          text-decoration: none;
          color: #bfbf92;
          font-weight:500;
          font-size: 14px;
          line-height: 40px;
          
        }

        .drawer-list a.iron-selected {
          color: #bfbf92;
          font-weight:500;
          font-size: 14px;
          background-color: gray;
        }
      </style>
      
      
      
      <app-location route="{{route}}" url-space-regex="^[[rootPath]]">
      </app-location>

      <app-route route="{{route}}" pattern="[[rootPath]]:page" data="{{routeData}}" tail="{{subroute}}">
      </app-route>

      <app-drawer-layout fullbleed narrow="{{narrow}}">
        <!-- Drawer content -->
        <app-drawer  id="drawer" slot="drawer" swipe-open="[[narrow]]">
          <app-toolbar style="background-color:gray; color:#ff5722">

              <vaadin-dropdown-menu id="application"  value-changed="_selectedMenu" >
                  <template>
                    <vaadin-list-box >
                      <vaadin-item value disabled>Select an Application</vaadin-item>
                      <template is="dom-repeat" items="{{application_data}}">
                          <vaadin-item  on-click="_selectedMenu" id="{{item.id}}" value="{{item.id}}">{{item.title}}</vaadin-item> 
                      </template>
                    </vaadin-list-box>
                  </template>
              </vaadin-dropdown-menu>

          </app-toolbar>

          <iron-selector selected="[[page]]" 
                         attr-for-selected="name" class="drawer-list" 
                         role="navigation" fallback-selection="0">

              <template is="dom-repeat" items="{{dashboard_data}}">
                <a name="{{item.id}}" href="[[rootPath]]{{item.id}}">{{item.title}}</a>
              </template>
             
          </iron-selector>

        </app-drawer>

        <!-- Main content -->
        <app-header-layout has-scrolling-region="">

          <app-header slot="header" condenses="" reveals="" effects="waterfall">
            <app-toolbar>HPCC DAS
            </app-toolbar>
          </app-header>

          <iron-pages id="pages" selected="[[page]]" attr-for-selected="name" selected-attribute="active" role="main">
             <template is="dom-repeat" items="{{dashboard_data}}">
                <dashboard-view name="{{item.id}}" dashboard_id="{{item.id}}" application_id="{{item.application_id}}"></dashboard-view> 
             </template>
          </iron-pages>
        </app-header-layout>
      </app-drawer-layout>
    `;
  }


  static get properties() {
    return {
      page: {
        type: String,
        reflectToAttribute: true,
        observer: '_pageChanged'
      },
      routeData: Object,
      subroute: Object,
      dashService: String,
      dashServiceContent: Object,
      dashboard_data: {
        type: Object
      },
      appService: String,
      appServiceContent: Object,
      application_data: {
        type: Object
      }

    };
  }

  //Can you get there with http://76.205.200.145:8010/#/stub/Main

  constructor() {
    super();

    this.dashService = Properties.get_das_server_url() + "/WsEcl/soap/query/roxie/das_dashboard_query.1";
    this.dashServiceContent = {
      "das_dashboard_query.1": {

      }
    };

    this.appService = Properties.get_das_server_url() + "/WsEcl/soap/query/roxie/das_application_query.1";
    this.appServiceContent = {
      "das_application_query.1": {

      }
    };
  }

  ready() {
    super.ready();

    Comm.getData(this.appService, this.appServiceContent, 'application', this);
  }

  _selectedMenu(e) {

    this.dashServiceContent = {
      "das_dashboard_query.1": {
         "application_id": e.target.id
      }
    };
    

    this.page = null;
    Comm.getData(this.dashService, this.dashServiceContent, 'dashboard', this);

  }

  receiveData(respType, resp) {
    
    if (respType == 'dashboard') {
     
      let dashResult = jsonPath(resp, '$..dashboard_data');
      this.dashboard_data = dashResult[0].Row;
      console.log("dashboard data - " + JSON.stringify(this.dashboard_data));
    
    } else if (respType == 'application') {

      let dashResult = jsonPath(resp, '$..application_data');
      this.application_data = dashResult[0].Row;
      console.log("application data - " + JSON.stringify(this.application_data));

    }

    window.history.pushState({}, null, '/');
    window.dispatchEvent(new CustomEvent('location-changed'));

  }

  static get observers() {
    return [
      '_routePageChanged(routeData.page)'
    ];
  }

  _routePageChanged(page) {

    this.page = page;
    if (!this.$.drawer.persistent) {
      this.$.drawer.close();
    }
  }

  _pageChanged(page) {

    if (page) {

      import('../views/dashboard-view.js');

    }
  }
}

window.customElements.define('my-app', MyApp);
