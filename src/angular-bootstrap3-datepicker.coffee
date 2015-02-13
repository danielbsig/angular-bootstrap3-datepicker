
dp = angular.module('ng-bs3-datepicker', [])

dp.directive 'ngBs3Datepicker', [ '$compile', ($compile)->
  restrict: 'E'
  scope:
    ngChange: "&"
    ngModel: "="
    minDate: "="
    maxDate: "="

  template: """
    <div class='input-group date'>
      <input type='text' class='form-control'/>
      <span class='input-group-addon'>
        <span class='fa fa-calendar'></span>
      </span>
    </div>
  """

  link: ($scope, element, attr)->

    dateFormat = ""
    minDate = undefined
    maxDate = undefined

    attributes = element.prop "attributes"
    input = element.find "input"
    resetValue = false

    angular.forEach( attributes, (e)->
      unless e.name is "class" or e.name is "id"
        input.attr e.name, e.value
      if e.name is "date-format"
        dateFormat = e.value
      else if e.name is "min-date"
        minDate = e.value
      else if e.name is "max-date"
        maxDate = e.value
      else if e.name is "id"
        input.id = e.value + "input"
    )

    $scope.$watch "minDate", (value)->
      console.log "watch minDate"
      console.log value
      if value
        dp = input.data("DateTimePicker")
        if dp
          console.log "Setting minDate"
          dp.setMinDate(value)
    , true

    $scope.$watch "maxDate", (value)->
      console.log "watch maxDate"
      console.log value
      if value
        dp = input.data("DateTimePicker")
        if dp
          console.log "Setting maxDate"
          dp.setMaxDate(value)
    , true

    $scope.$watch attr.language, (value)->
      language = if value then value else input.attr('language')
      input.datetimepicker(
        language: language
        pickTime: false
        format:   dateFormat
        minDate:  $scope.minDate
        maxDate:  $scope.maxDate
        icons:
            time: 'fa fa-clock-o'
            date: 'fa fa-calendar'
            up:   'fa fa-arrow-up'
            down: 'fa fa-arrow-down'
      )

    #allow addon to be clicked in place of the input itself
    element.find('.input-group-addon').on 'click', (e)->
      element.find('input').focus()

    #update model from date picker change value
    element.on "change.dp",(e)->
      console.log "on change dp - before $scope.$apply"
      dp = input.data("DateTimePicker")

      $scope.$apply ->
        if dp.date
          $scope.ngModel = dp.date.format(dateFormat)
          if $scope.ngChange
            $scope.ngChange({value: dp.date})

    $scope.$watch attr.ngModel, (newValue, oldValue)->
      if(oldValue and !newValue) then resetValue = true

    $compile(input)($scope)
]