import { html, LitElement } from '@polymer/lit-element';
import '../components/hpcc-chart.js';
import { sharedStyles } from '../styles/shared-styles.js';
import {Comm} from '../js/Comm.js';
import {Properties} from '../js/Properties.js';

class DashboardView extends LitElement {
   

  render() {
    return html`
             ${sharedStyles} 
      
             
             ${this._charts_data.map((item) => html`

                  <hpcc-chart 
                    style="width:98%" 
                    chart_type="${item.chart_type}" 
                    dataset_name="${item.dataset_name}" query_name="${item.query_name}" 
                    chart_title="${item.title}"
                    has_drilldown="${item.has_drilldown}"
                    drilldown_dashboard_id="${item.drilldown_dashboard_id}"
                    drilldown_application_id="${item.drilldown_application_id}">
                  </hpcc-chart>

             `)}
    `;
  }



  constructor () {
    super();
    this._can_render = false;
    this.active = false;
    this._charts_data = [];
    this.isInitData = false;
  }

  static get properties() {
    return {
      dashboard_id: {type: String},
      application_id: {type: String},
      active: {type: Boolean},
      _charts_data: {type: Object},
      _dashboard_view: {type: Object}
    }
  }


  get active() {
    return this.getAttribute('active');
  }


  set active(value) {
    this.setAttribute('active', value);
    console.log('set active: ' + value  + '  - dashboard id - ' + this.dashboard_id); 
    if (value == true) {
      this.initData();//Call promise to fetch data
    }
  }

  initData() {
    let serviceURL = Properties.get_das_server_url() + "/WsEcl/soap/query/roxie/das_dashboard_charts_query.1";
    let serviceContent = {
      "das_dashboard_charts_query.1": {
        "dashboard_id": this.dashboard_id,
        "application_id": this.application_id
      }
    };

    Comm.getData(serviceURL, serviceContent, 'dashboard_charts' ,this);

    console.log('init data called: ' + this.dashboard_id +
      ' , Service URL: ' + serviceURL +
      ', Content:  ' + JSON.stringify(serviceContent));
  }


  receiveData(respType, resp) {
    this.isInitData = true;
    let dashResult = jsonPath(resp, '$..dashboard_charts_data');
    this._charts_data = dashResult[0].Row;

    console.log('[dashboard-view] charts data:');
    console.log(JSON.stringify(this._charts_data));

    this._invalidate();
  }
}

window.customElements.define('dashboard-view', DashboardView);