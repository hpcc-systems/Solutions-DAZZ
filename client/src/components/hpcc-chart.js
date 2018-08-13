import { LitElement, html} from '@polymer/lit-element';
import {render} from 'lit-html'
import {sharedStyles} from '../styles/shared-styles.js';
import {Comm} from '../js/Comm.js';
import '../views/drilldown-view.js';
import { repeat } from 'lit-html/lib/repeat';
import {Properties} from '../js/Properties.js';


class HPCCChart extends LitElement {


  constructor() {
    super();

    console.log('[hpcc-chart] Constructor');
  }

  _render({ chart_title, has_drilldown }) {
    console.log('[hpcc-chart] Render');

    return html`
      
      ${sharedStyles}
      <style>
        :host {
          display: block;

          padding: 10px;
        }

        .tbl tr:hover {background-color: lightgray;}

        div.link {color: black;text-decoration:none;}
        div.link:hover {text-decoration:underline;}

      </style>

      
      <drilldown-view hidden='true' id="drilldown"></drilldown-view> 
       
      <div class="card">
        <h1>${chart_title}</h1>
        <div id="main" style="min-height:500px;" ></div>
        <div hidden="${!has_drilldown}" style="color: gray"><h2>You can drilldown on this chart by selecting a slice/bar</h2></div>
      </div>

      
    `;
  }


  static get properties() {
    return {
      chart_title: String,
      chart_type: String,
      dataset_name: String,
      query_name: String,
      filter_1: String,
      filter_2: String,
      has_drilldown: Boolean,
      drilldown_application_id: String,
      drilldown_dashboard_id: String,
    }
  }

  

  _didRender(props, changedProps, prevProps) {
    console.log('[hpcc-chart]' + ' Render complete');
    console.log('[hpcc-chart]' + ' query name: ' + this.query_name);
    console.log('[hpcc-chart]'+ ' chart title: ' + this.chart_title);

    let queryName = this.query_name;

    let serviceURL = Properties.get_das_server_url() + "/WsEcl/soap/query/roxie/" + queryName;

    let serviceContent = {
      [queryName]: {
        "dataset_name": this.dataset_name,
        "filter_1": this.filter_1,
        "filter_2": this.filter_2
      }
    };

    Comm.getData(serviceURL, serviceContent, this.chart_type, this);
  }
  
  _chartClick(params) {
    console.log('[hpcc-chart]' + 'name:' + params.name + '  series name: ' + params.seriesName + ' component Type: ' + params.componentType);
    console.log('[hpcc-chart]' + 'drilldown dashboard id:' + this.drilldown_dashboard_id  + '   drilldown application id:' + this.drilldown_application_id  + '  filter 1: ' + params.name);
    
    let dialog = this.shadowRoot.querySelector('#drilldown');
    dialog.dashboard_id = this.drilldown_dashboard_id;
    dialog.application_id = this.drilldown_application_id;

    dialog.filter_1 = params.name;
    dialog.filter_2 = params.seriesName;

    dialog.open();
  }

  _tableRowClick(param) {
    let dialog = this.shadowRoot.querySelector('#drilldown');
    dialog.dashboard_id = this.drilldown_dashboard_id;
    dialog.application_id = this.drilldown_application_id;

    dialog.filter_1 = '';
    dialog.filter_2 = param;

    dialog.open();
  }

  _tableColumnClick(param) {
    let dialog = this.shadowRoot.querySelector('#drilldown');
    dialog.dashboard_id = this.drilldown_dashboard_id;
    dialog.application_id = this.drilldown_application_id;

    dialog.filter_1 = param;
    dialog.filter_2 ='';

    dialog.open();
  }

  plotTable (columns, rows){ 
    return html`
        <table style="width:100%; border: 1px solid black;border-collapse: collapse;" id="main" class="tbl">
        <tr>
        
        ${repeat(columns, (item) => html`
          <th style="background-color:lightgray;text-align:left;border: 1px solid black"><div class='link' onclick="${() => this._tableColumnClick(item)}">${item}<div></th>
        `)}
        </tr>

        ${repeat(rows, (ritem) => html`
          <tr>
          ${repeat(ritem, (citem, index) => html`
            <td style="${index==0  ? 'font-weight:bold' : ''};border: 1px solid black">
                ${index==0  ? html`<div class='link' onclick="${() => this._tableRowClick(citem)}">${citem}</div>` : citem}
            </td>
          `)}
          </tr>
        `)}
        </table>
      `;
  }

  receiveData(respType, resp) {
    
    let chartResult = jsonPath(resp, '$..chart_data');
    
    if (!chartResult) return;//No data is returned. Need to log this as this should never happen

    let chartMeta = chartResult[0].Row[0];
    if (chartMeta.title) this.chart_title = chartMeta.title;
    let chartData = chartMeta.row_data.Row;

    if (respType == 'bar' || respType == 'line') {
 
      var chart = echarts.init(this.shadowRoot.querySelector('#main'));
      chart.width = "100%";
      chart.on('click', (params) => this._chartClick(params));

      var option = {
        tooltip: {},
        toolbox: {
          show: true,
          orient: 'vertical',
          left: 'right',
          top: 'center',
          feature: {
            mark: { show: true },
            dataView: { show: true, readOnly: false },
            magicType: { show: true, type: ['line', 'bar', 'stack', 'tiled'] },
            restore: { show: true },
            saveAsImage: { show: true }
          }
        },
        legend: {
          data: []
        },
        xAxis: {
          data: []
        },
        yAxis: {},
        series: []

      };


      for (var i = 0; i < chartData.length; i++) {

        var series_label = chartData[i].series_label;
        var series_data = [];

        var columnData = chartData[i].column_data.Row;

        for (var j = 0; j < columnData.length; j++) {
          if (i == 0) {
            option.xAxis.data.push(columnData[j].column_label);
          }
          series_data.push(columnData[j].value)
        }

        var type = respType;

        var series_obj = {

          type: type,
          name: series_label,
          data: series_data //i.e. Values of a series_label for every xAxis (e.g. Revenues of Odyssey (i.e. the series label) for Q1,Q2,Q3,Q4)

        }
        option.series.push(series_obj);
        option.legend.data.push(series_label);
      }
      
      chart.setOption(option, true);

    } else if (respType == 'pie' ) { //Pie Chart

      var chart = echarts.init(this.shadowRoot.querySelector('#main'));
      chart.width = "100%";
      chart.on('click', (params) => this._chartClick(params));

      var option = {
        tooltip: {},
        legend: {
          data: []
        },
        series: []
      };

      var series_obj = {
        type: 'pie',
        data: []
      }

      for (var i = 0; i < chartData.length; i++) {

        var series_label = chartData[i].series_label;

        var columnData = chartData[i].column_data.Row;

        series_obj.data.push({ value: columnData[0].value, name: series_label });

        option.legend.data.push(series_label);
      }

      option.series.push(series_obj);

      chart.setOption(option, true);

    } else if (respType = 'table') {

      let columnHeaders = [];
      columnHeaders.push('');

      let rows = [];
   
      for (var i = 0; i < chartData.length; i++) {

          let row = [];
          row.push(chartData[i].series_label);

          var columnData = chartData[i].column_data.Row;

          for (var j = 0; j < columnData.length; j++) {
              if (i == 0) {
                  columnHeaders.push(columnData[j].column_label);
              }
              row.push(columnData[j].value)
          }

          rows.push(row);
      }

      let chart = this.shadowRoot.querySelector('#main');
      render(this.plotTable(columnHeaders, rows), chart);

    }

  }

}
customElements.define('hpcc-chart', HPCCChart);