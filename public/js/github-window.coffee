define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    class GithubWindow extends WindowView
        className:'github-window'
        template: _.template $('#github-template').html()
        el: '.github'
        url : 'https://api.github.com/users/jarodreyes/events/public'

        regions:
            'gits': '.git-commits'

        initialize: ->
            @getData()
            super

        toggleWindow: (event) ->
            @gits.show @gitCollectionView
            (@$ 'small').toggleClass 'invisible'
            super

        getData: () ->
            $.get @url, (data) =>
                @data = data
                do @prepareData

        prepareData: () ->
            gits = []
            for item in @data
                if item.type is "PushEvent"
                    item.created_at = new Date(item.created_at).toLocaleString()
                    gits.push item
            @gitList = new Backbone.Collection gits
            do @renderGits

        renderGits: ->
            @gitCollectionView = new GitCollectionView
                collection: @gitList

    class GitView extends Backbone.Marionette.ItemView
        template: _.template $('#git-template').html()

    class GitCollectionView extends Backbone.Marionette.CollectionView
        itemView: GitView

    return GithubWindow