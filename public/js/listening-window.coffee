define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    class ListeningWindow extends WindowView
        className:'listening-window'
        template: _.template $('#listening-template').html()
        el: '.listening'
        url : 'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=jardy7&api_key=b43247deffdcc1127871216484cc1687&format=json&limit=20'

        additionalEvents:
            'click a.next': 'slideNext'
            'click a.prev': 'slidePrev'

        regions:
            'songs': '.song-list'

        ui:
            'window': '.window'
        initialize: ->
            @getData()
            @scrollable = true
            @pages = 19
            super

        toggleWindow: (event) ->
            @songs.show @songCollectionView
            @ui.window.append _.template $('#scroll-controls').html()
            (@$ 'small').toggleClass 'invisible'
            super

        getData: ->
            $.get @url, (data) =>
                @data = data.recenttracks.track
                do @prepareData

        prepareData: ->
            for track in @data
                track.image_url = track.image[3]['#text']
                track.artist_name = track.artist['#text']
            @trackList = new Backbone.Collection @data
            do @renderTracks

        renderTracks: ->
            @songCollectionView = new SongCollectionView
                collection: @trackList
                className: 'inner-scroll'

    class SongView extends Backbone.Marionette.ItemView
        template: _.template $('#song-template').html()

    class SongCollectionView extends Backbone.Marionette.CollectionView
        itemView: SongView
        itemViewOptions:
            className: 'song-preview card'
            tagName: 'li'

    return ListeningWindow