import { html, LitElement } from '@polymer/lit-element';
import '../components/hpcc-chart.js';
import { SharedStyles } from '../styles/shared-styles.js';
import '../js/comm.js';
import { repeat } from 'lit-html/lib/repeat.js';

class DashboardView extends LitElement {
   

  _render({_charts_data, _dashboard_view}) {
    return html`
      ${SharedStyles}
      
             ${repeat(_charts_data, (item) => html`
                 
                <hpcc-chart style="width:98%" chart_type="${item.chart_type}" 
                  dataset_name="${item.dataset_name}" query_name="${item.query_name}" 
                  chart_title="${item.title}"
                  has_drilldown="${item.has_drilldown}"
                  drilldown_dashboard_id="${item.drilldown_dashboard_id}"></hpcc-chart>

             `)}
    `;
  }


  constructor () {
    super();
    this._can_render = false;
    this._charts_data = [];
  }

  static get properties() {
    return {
      dashboard_id: String,
      active: Boolean,
      _charts_data: Object,
      _dashboard_view: Object
    }
  }

  _shouldRender(props, changedProps, old) {
    console.log('_shouldRender called, props active: ' + props.active + ' can render: ' + this._can_render);
 
    if (props.active && !this._can_render) {
      this._init();//Call promise to fetch data
    } 

    return this._can_render;
  }

  _didRender(props, changedProps, prevProps)  {
    this._can_render = false;
    
    console.log('[dashboard-view] Render complete');
  }

  _init() {
    let serviceURL = "http://play.hpccsystems.com:8002/WsEcl/soap/query/roxie/das_dashboard_charts_query.1";
    let serviceContent = {
      "das_dashboard_charts_query.1": {
        "dashboard_id": this.dashboard_id
      }
    };

    Comm.getData(serviceURL, serviceContent, 'dashboard_charts' ,this);

    console.log('init data called: ' + this.dashboard_id +
      ' , Service URL: ' + serviceURL +
      ', Content:  ' + JSON.stringify(serviceContent));
  }


  receiveData(respType, resp) {
    let dashResult = jsonPath(resp, '$..dashboard_charts_data');
    this._charts_data = dashResult[0].Row;

    console.log('[dashboard-view] charts data:');
    console.log(JSON.stringify(this._charts_data));

    this._can_render = true;
    this.requestRender();
  }
}

window.customElements.define('dashboard-view', DashboardView);