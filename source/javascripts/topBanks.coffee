$ ->
  topBanksSQL = "https://milafrerichs.cartodb.com/api/v2/sql?q=SELECT COUNT(cartodb_id) as banks, country FROM failed_bank_tracker_geom GROUP BY country ORDER BY banks DESC LIMIT 10"

  d3.json topBanksSQL, (data) ->
    data = data.rows
    padding = 40
    width = $('#top-10').width() - padding
    barchart = new Barchart(data, { width: width })
    barchart.setXDomain(data.map((d) -> d.country))
    barchart.setYDomain([0,d3.max(data, (d) -> d.banks)])
    barchart.setValueKey('banks')
    barchart.setGroupKey('country')
    barchart.render('#top-10-chart')
