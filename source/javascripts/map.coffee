width = document.getElementById('map').clientWidth
height = 650
legendElementWidth = 20
legendElementHeight = 20

scale = 600
center = [4,70]
projection = d3.geo.mercator().scale(scale).translate([width/2, 0]).center(center)
path = d3.geo.path().projection(projection)
colors = colorbrewer.Reds[8]

countryTooltipHtml = $("#country-tooltip").html()
countryTooltip = Handlebars.compile(countryTooltipHtml)
bankTooltipHtml = $("#bank-tooltip").html()
bankTooltip = Handlebars.compile(bankTooltipHtml)

svg = d3.select("#map").append("svg").attr("height", height).attr("width", width)

bankScale = d3.scale.quantile().range(colors)

findScore = (banks, d) ->
  _.findWhere(banks, { Country: d.properties.name })

tooltipHtml = (d, data) ->
  dataCount = if data then data.count else 0
  dataObj = {name: d.properties.name, dataCount: dataCount }
  countryTooltip(dataObj)

tooltipBankHtml = (d) ->
  bankTooltip(d.properties)

countries = svg.append("g")
bankL = svg.append("g").attr('class','banks')

europeTopojson = "data/eu.json"
failedBanks = "data/failed_per_country.csv"
cartodbSQL = 'https://milafrerichs.cartodb.com/api/v2/sql?format=GeoJSON&q=SELECT *,to_char(start_date,\'YYYY\') as start_date_formatted,to_char(end_date,\'YYYY\') as end_date_formatted FROM failed_bank_tracker_geom'

queue()
  .defer(d3.json,europeTopojson)
  .defer(d3.csv, failedBanks)
  .defer(d3.json, cartodbSQL)
  .await  (error, topo, banks, bankList) ->
    bankScale.domain(d3.extent(banks, (d) -> parseInt(d.count)))
    countries.selectAll(".country")
    .data(topojson.feature(topo, topo.objects.europe).features)
    .enter()
    .append("path")
    .attr("class", "country")
    .attr("d", path)
    .attr("fill", (d) ->
      score = findScore(banks,d)
      if score then bankScale(score.count) else "#fefefe"
    )
    .on("mouseover", (d) ->
      d3.select(this).classed("active", true)
      d3.select("#tooltip")
      .classed("country", true)
      .classed("bank", false)
      .html(tooltipHtml(d, findScore(banks, d)))
      .style("opacity", 1))
    .on("mouseout", (d) -> d3.select(this).classed("active", false))
    .on("mousemove", (d) ->
      d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px")
      .style("top", (d3.event.pageY - 32) + "px")
    )

    svgLegend = d3.select("#legend")
    .append("svg").attr('width',40).attr('height',180)
    legend = svgLegend.selectAll(".legend")
    .data([0].concat(bankScale.quantiles()), (d) -> d)
    .enter().append("g")
    .attr("class", "legend")
    legend.append("rect")
    .attr("y", (d, i) -> legendElementHeight * i)
    .attr("x", 0)
    .attr("width", legendElementWidth)
    .attr("height", legendElementHeight)
    .style("fill", (d, i) -> colors[i])
    legend.append("text")
    .attr("class", "mono")
    .text((d) -> "≥ " + Math.round(d))
    .attr("y", (d, i) -> legendElementHeight * i)
    .attr("x", legendElementHeight)

    bankL.selectAll('.bank')
    .data(bankList.features)
    .enter()
    .append("path")
    .attr("class","bank")
    .attr("d",path)
    .on("mouseover", (d) ->
      d3.select(this).classed("active", true)
      d3.select("#tooltip")
      .classed("country", false)
      .classed("bank", true)
      .html(tooltipBankHtml(d))
      .style("opacity", 1)
    )
    .on("mouseout", (d) -> d3.select(this).classed("active", false))
    .on("mousemove", (d) ->
      d3.select("#tooltip").style("left", (d3.event.pageX + 14) + "px")
      .style("top", (d3.event.pageY - 32) + "px")
    )
    return
