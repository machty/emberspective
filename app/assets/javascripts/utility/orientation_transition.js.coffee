Emberspective.OrientationTransition = Ember.CoreObject.extend()

Emberspective.OrientationTransition.between = (before, after) ->
  Emberspective.OrientationTransition.create
    beforeFocus: before
    afterFocus: after
    transform: after.inverse()


