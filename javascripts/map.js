(function() {
  var bankScale, center, colors, countries, europeTopojson, failedBanks, findScore, height, legendElementHeight, legendElementWidth, path, projection, scale, svg, tooltipHtml, width;

  width = document.getElementById('map').clientWidth;

  height = 650;

  legendElementWidth = 20;

  legendElementHeight = 20;

  scale = 600;

  center = [4, 70];

  projection = d3.geo.mercator().scale(scale).translate([width / 2, 0]).center(center);

  path = d3.geo.path().projection(projection);

  colors = colorbrewer.Reds[8];

  svg = d3.select("#map").append("svg").attr("height", height).attr("width", width);

  bankScale = d3.scale.quantile().range(colors);

  findScore = function(banks, d) {
    return _.findWhere(banks, {
      Country: d.properties.name
    });
  };

  tooltipHtml = function(d, data) {
    var dataCount;
    dataCount = data ? data.count : 0;
    return "<h4>" + d.properties.name + "</h4><p>Failed Banks: " + dataCount + "</p>";
  };

  countries = svg.append("g");

  europeTopojson = "data/eu.json";

  failedBanks = "data/failed_per_country.csv";

  queue().defer(d3.json, europeTopojson).defer(d3.csv, failedBanks).await(function(error, topo, banks) {
    var legend, svgLegend;
    bankScale.domain(d3.extent(banks, function(d) {
      return parseInt(d.count);
    }));
    countries.selectAll(".country").data(topojson.feature(topo, topo.objects.europe).features).enter().append("path").attr("class", "country").attr("d", path).attr("fill", function(d) {
      var score;
      score = findScore(banks, d);
      if (score) {
        return bankScale(score.count);
      } else {
        return "#fefefe";
      }
    }).on("mouseover", function(d) {
      d3.select(this).classed("active", true);
      return d3.select("#tooltip").html(tooltipHtml(d, findScore(banks, d))).style("opacity", 1);
    }).on("mouseout", function(d) {
      return d3.select(this).classed("active", false);
    }).on("mousemove", function(d) {
      return d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px").style("top", (d3.event.pageY - 22) + "px");
    });
    svgLegend = d3.select("#legend").append("svg").attr('width', 40).attr('height', 180);
    legend = svgLegend.selectAll(".legend").data([0].concat(bankScale.quantiles()), function(d) {
      return d;
    }).enter().append("g").attr("class", "legend");
    legend.append("rect").attr("y", function(d, i) {
      return legendElementHeight * i;
    }).attr("x", 0).attr("width", legendElementWidth).attr("height", legendElementHeight).style("fill", function(d, i) {
      return colors[i];
    });
    legend.append("text").attr("class", "mono").text(function(d) {
      return "≥ " + Math.round(d);
    }).attr("y", function(d, i) {
      return legendElementHeight * i;
    }).attr("x", legendElementHeight);
  });

}).call(this);
