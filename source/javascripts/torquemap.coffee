$ ->
  torquePath = 'https://milafrerichs.cartodb.com/api/v2/viz/47c94ac8-d6b0-11e4-8e7f-0e018d66dc29/viz.json'

  cartodb.createVis('torque-map',torquePath, {
    shareable: true,
    title: true,
    description: true,
    search: true,
    tiles_loader: true,
    loaderControl: true,
    time_slider: true
  })
