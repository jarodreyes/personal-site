// Generated by CoffeeScript 1.4.0
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define(['window', 'jquery.xml2json'], function(WindowView, xml2json) {
  var BookView, BooksCollectionView, ReadingWindow;
  String.prototype.trunc = function(n) {
    return this.substr(0, n - 1) + (this.length > n ? '...' : '');
  };
  ReadingWindow = (function(_super) {

    __extends(ReadingWindow, _super);

    function ReadingWindow() {
      return ReadingWindow.__super__.constructor.apply(this, arguments);
    }

    ReadingWindow.prototype.className = 'reading-window';

    ReadingWindow.prototype.template = _.template($('#reading-template').html());

    ReadingWindow.prototype.el = '.reading';

    ReadingWindow.prototype.url = 'http://www.goodreads.com/review/list/5406984.xml?key=Nkya34MwrAyEZ7cnbMzqA&v=2&shelf=read';

    ReadingWindow.prototype.additionalEvents = {
      'click a.next': 'slideNext',
      'click a.prev': 'slidePrev'
    };

    ReadingWindow.prototype.regions = {
      books: '.book-list'
    };

    ReadingWindow.prototype.ui = {
      'window': '.window'
    };

    ReadingWindow.prototype.initialize = function() {
      this.getReadingData();
      this.scrollable = true;
      return ReadingWindow.__super__.initialize.apply(this, arguments);
    };

    ReadingWindow.prototype.toggleWindow = function(event) {
      this.books.show(this.booksCollectionView);
      this.ui.window.append(_.template($('#scroll-controls').html()));
      (this.$('small')).toggleClass('invisible');
      return ReadingWindow.__super__.toggleWindow.apply(this, arguments);
    };

    ReadingWindow.prototype.getReadingData = function() {
      var _this = this;
      return $.get(this.url, function(xml) {
        var data;
        data = $.xml2json(xml);
        _this.model = new Backbone.Model(data.reviews);
        return _this.prepareData();
      });
    };

    ReadingWindow.prototype.prepareData = function() {
      var image, review, reviews, title, _i, _len;
      reviews = this.model.get('review');
      for (_i = 0, _len = reviews.length; _i < _len; _i++) {
        review = reviews[_i];
        image = review.book.image_url;
        image = image.replace(/m\/(?=\d)/g, 'l/');
        review.book.image_url = image;
        title = review.book.title;
        title = title.trunc(25);
        review.book.title = title;
      }
      this.bookList = new Backbone.Collection(reviews);
      return this.renderBooks();
    };

    ReadingWindow.prototype.renderBooks = function() {
      return this.booksCollectionView = new BooksCollectionView({
        collection: this.bookList,
        className: 'inner-scroll'
      });
    };

    return ReadingWindow;

  })(WindowView);
  BookView = (function(_super) {

    __extends(BookView, _super);

    function BookView() {
      return BookView.__super__.constructor.apply(this, arguments);
    }

    BookView.prototype.template = _.template($('#books-template').html());

    return BookView;

  })(Backbone.Marionette.ItemView);
  BooksCollectionView = (function(_super) {

    __extends(BooksCollectionView, _super);

    function BooksCollectionView() {
      return BooksCollectionView.__super__.constructor.apply(this, arguments);
    }

    BooksCollectionView.prototype.itemView = BookView;

    BooksCollectionView.prototype.itemViewOptions = {
      className: 'book-preview card',
      tagName: 'li'
    };

    return BooksCollectionView;

  })(Backbone.Marionette.CollectionView);
  return ReadingWindow;
});