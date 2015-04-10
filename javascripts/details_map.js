(function() {
  var detailMapPath;

  detailMapPath = 'https://milafrerichs.cartodb.com/api/v2/viz/4503c3ee-df62-11e4-98d2-0e9d821ea90d/viz.json';


  /*
  detailMap= new L.Map('detail-map', {
  	center: [4,70],
  	zoom: 3
  })
  
  L.tileLayer('http://tile.stamen.com/toner/{z}/{x}/{y}.png', {
  	attribution: 'Stamen'
  }).addTo(detailMap)
  
  cartodb.createLayer(detailMap,detailMapPath).addTo(detailMap)
  .on('done', (layer) ->
    layer.setInteraction true
    layer.on 'featureOver', (e, latlng, pos, data) ->
      cartodb.log.log e, latlng, pos, data
      return
    layer.on 'error', (err) ->
      cartodb.log.log 'error: ' + err
      return
    return
  ).on 'error', ->
    cartodb.log.log 'some error occurred'
   */

}).call(this);
