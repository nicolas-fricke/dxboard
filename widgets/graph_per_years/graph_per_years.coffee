class Dashing.GraphPerYears extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points_current_year')
    if points
      points[points.length - 1].y

  ready: ->
    container = $(@node).parent()
    console.log('hey ho')
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'bar'
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}]
        },
        {
          color: "##1d9fe3",
          data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('points_current_year') if @get('points_current_year')
    @graph.series[1].data = @get('points_past_year') if @get('points_past_year')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.points_current_year
      @graph.series[1].data = data.points_past_year
      @graph.render()
