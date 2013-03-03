class UserDashboard.Views.AssessmentDetailsView extends Backbone.View
  template: JST['dashboard/containers/assessment_details_view']

  initialize: (options) ->


  render: ->
    $(@el).html(@template())
    @delegateEvents()
    this