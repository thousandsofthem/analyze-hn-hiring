$(document).ready(function () {


  drawChart("#container-1", 'Term popularity by date', "", window.points);
  drawChart("#container-2", 'Term popularity by date (normalized)', "%", window.points_normalized);

  $( ".show-all" ).click(function(e) {
    e.preventDefault();
    var chart = $($(this).data('target')).highcharts();
    for (i in chart.series) {
      var name = chart.series[i].name;
      if (name != "ONSITE" && name != "REMOTE" && name != "TOTAL" && !chart.series[i].visible) {
        chart.series[i].show();
      }
    }
  });

  $( ".hide-all" ).click(function(e) {
    e.preventDefault();
    var chart = $($(this).data('target')).highcharts();
    for (i in chart.series) {
      if (chart.series[i].visible) {
        chart.series[i].hide();
      }
    }
  });


});


function drawChart(container, title, suffix, points) {
  var series = [];
  var v;
  for (k in points) {
    v = points[k];
    var serie = {name: k, data: v, visible: false}

    if (k == "TOTAL") {
      //serie.visible = false;
    }
    if (k == "onsite") {
      serie.name = 'ONSITE';
      //serie.visible = false;
    }
    if (k == "remote") {
      serie.name = 'REMOTE';
      //serie.visible = false;
    }
    series.push(serie);
  }

  $(container).highcharts({
    chart: {
      height: $(document).height() - 50
    },
    title: {
        text: title
    },
    tooltip: {
        shared: true,
        valueSuffix: suffix
    },
    xAxis: {
        type: 'datetime'
    },
    yAxis: {
        title: {
            text: false
        }
    },
    legend: {
        enabled: true
    },
    plotOptions: {
        area: {}
    },

    series: series
  });
}