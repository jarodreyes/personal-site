define ['window', 'jquery.xml2json'], 
(WindowView, xml2json) ->
    class ReadingWindow extends WindowView
        className:'reading-window'
        template: _.template $('#reading-template').html()
        el: '.reading'
        url: 'http://www.goodreads.com/review/list/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA&v=2&shelf=read'
        # secret: vJEOgLqaHHBf8J1lZxgHYwZ0TszZSJDNfQnULnKmLIQ

        regions:
            books: '.book-list'

        initialize: ->
            @getReadingData()
            super

        toggleWindow: (event) ->
            @books.show @booksCollectionView
            (@$ 'small').toggleClass 'invisible'
            super

        getReadingData: () ->
            $.get @url, (xml) =>
                data = $.xml2json(xml)
                @model = new Backbone.Model data.reviews
                @prepareData()

        prepareData: () ->
            reviews = @model.get 'review'
            for review in reviews
                image = review.book.image_url
                image = image.replace /m\/(?=\d)/g, 'l/'
                review.book.image_url = image
            @bookList = new Backbone.Collection reviews
            @renderBooks()

        renderBooks: ->
            @booksCollectionView = new BooksCollectionView
                collection: @bookList

    class BookView extends Backbone.Marionette.ItemView
        template: _.template $('#books-template').html()

    class BooksCollectionView extends Backbone.Marionette.CollectionView
        itemView: BookView

    return ReadingWindow