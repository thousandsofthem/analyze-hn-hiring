$(document).ready(function () {
  drawChart(window.points);


  $( "#show-all" ).click(function(e) {
    e.preventDefault();
    var chart = $('#container').highcharts();
    for (i in chart.series) {
      var name = chart.series[i].name;
      if (name != "ONSITE" && name != "REMOTE" && name != "TOTAL") {
        chart.series[i].show();
      }
    }
  });

  $( "#hide-all" ).click(function(e) {
    e.preventDefault();
    var chart = $('#container').highcharts();
    for (i in chart.series) {
      chart.series[i].hide();
    }
  });


});


function drawChart(points) {
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

  $('#container').highcharts({
    chart: {
      height: $(document).height() - 50
    },
    title: {
        text: 'Term popularity by date'
    },
    tooltip: {
        shared: true,
      //  valueSuffix: ''
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