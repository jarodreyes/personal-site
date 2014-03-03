class Leaderboard extends Backbone.Marionette.Layout
    template: '#leaderboard'
    regions:
        scores: '.scores'

    initialize: ->
        @currentSlug = null
        @players = new Players
        @content = new AnswerContent
        @listenTo @players, 'sync', @getScores
        @answersurl = "https://spreadsheets.google.com/feeds/list/0AmkZRXO39XOSdDkzZ1JveHBnZWxzYkFqN3htSHRFbWc/od6/public/values?alt=json"

    onRender: ->
        @players.fetch()

    loadAnswers: (model) ->
        $.ajax
            url: @answersurl,
            dataType: "json",
            type: 'GET',
            success: (res) =>
                score = 0
                correct = []
                _.each res['feed']['entry'], (cell, idx) =>
                    _.each model.attributes, (val, key) =>
                        gkey = key.toLowerCase()
                        answer = cell["gsx$#{gkey}"]
                        if answer
                            if val == answer['$t']
                                score += 3
                                correct.push "<span> #{key}: 1st Guess #{val} </span>"
                            if val == answer['$t']
                                score += 1
                                correct.push "<span> #{key}: 2nd Guess #{val} </span>"
                        model.set 'score', score
                        model.set 'correct', correct
        
    getScores: (reload = true) =>
        _.each @players.models, (model) =>
            if reload
                model.set('score', 0)
                model.set('correct', '')
            @loadAnswers(model)
            _.defer =>
                if reload
                    do @showPlayers
                @players.sort()

    showPlayers: ->
        @scoreBoard = new Scoreboard 
            collection: @players
        @scores.show @scoreBoard


class Player extends Backbone.Marionette.ItemView
    template: '#player'
    className: 'player'
    events:
        'click': 'showCorrect'

    showCorrect: ->
        (@$ '.answers').toggleClass 'slide'

class Scoreboard extends Backbone.Marionette.CollectionView
    itemView: Player

class Players extends Backbone.Collection
    url: "js/oscars.json"
    comparator: (model) -> 
        return -model.get('score')

class AnswerContent extends Backbone.Model
    url: "https://spreadsheets.google.com/feeds/list/0AmkZRXO39XOSdDkzZ1JveHBnZWxzYkFqN3htSHRFbWc/od6/public/values?alt=json"


$(document).ready(
    ->
        lb = new Leaderboard
            el: ".leaderboard"
        lb.render()
)