// Generated by CoffeeScript 1.4.0
(function() {
  var ConstructSlider;

  ConstructSlider = (function() {

    function ConstructSlider() {
      this.nav = $('nav.slides-nav');
      this.container = $('#slides');
      this.inner = this.container.find('.slides-container');
      this.setInnerWidth();
      this.setupArrows();
      this.setupDrawerNav();
      this.setupWindowResizer();
      this.setupKeybindings();
    }

    ConstructSlider.prototype.setInnerWidth = function() {
      var width;
      width = null;
      $(".slides-container section").each(function() {
        return width = width + $(this).outerWidth(true) + 3;
      });
      return $(this.inner).css('width', width);
    };

    ConstructSlider.prototype.setupArrows = function() {
      var _this = this;
      return $('.main-nav').on('click', '.arrow', function(event) {
        var id;
        id = $(event.target).attr('data-id');
        _this.slideNext(id);
        return _this.hideDrawer();
      });
    };

    ConstructSlider.prototype.slideNext = function(id) {
      var $current, $next, index, pxVal, viewportW, width;
      viewportW = this.viewportWidth();
      $current = $(this.container).find('.active');
      index = $(this.inner).find('section').index($current);
      if (id === "next") {
        $next = $current.next();
        width = (index + 1) * 90;
        pxVal = (viewportW * (index + 1)) * (90 / 100);
      } else if (id = "prev") {
        $next = $current.prev();
        width = (index - 1) * 90;
        pxVal = (viewportW * (index - 1)) * (90 / 100);
      }
      if ($next.length) {
        $(this.inner).css('transform', "translateX(-" + pxVal + "px)");
        $current.removeClass('active');
        return $next.addClass('active');
      }
    };

    ConstructSlider.prototype.setupDrawerNav = function() {
      var _this = this;
      $('.menu').click(function() {
        return _this.toggleDrawer();
      });
      return $('.drawer a').on('click', function(event) {
        var $current, $target, currentIndex, dataId, pxVal, targetIndex, viewportW;
        dataId = $(event.target).attr('href');
        dataId = dataId.replace("#", "");
        $target = $("[data-id='" + dataId + "']");
        targetIndex = $(_this.inner).find('section').index($target);
        $current = _this.container.find('.active');
        currentIndex = _this.inner.find('section').index($current);
        if (targetIndex !== currentIndex) {
          viewportW = _this.viewportWidth();
          pxVal = (viewportW * targetIndex) * (90 / 100);
          _this.inner.css('transform', "translateX(-" + pxVal + "px)");
          $($current).removeClass('active');
          $target.addClass('active');
          return _this.hideDrawer();
        }
      });
    };

    ConstructSlider.prototype.toggleDrawer = function(val) {
      if (val === "close" || this.container.hasClass('show-nav')) {
        return $(this.container).removeClass('show-nav').addClass('hide-nav');
      } else if (val = 'open' || this.container.hasClass('show-nav')) {
        return $(this.container).removeClass('hide-nav').addClass('show-nav');
      }
    };

    ConstructSlider.prototype.hideDrawer = function() {
      var _this = this;
      if ($(this.container).hasClass('show-nav')) {
        return this.inner.on("transitionend webkitTransitionEnd MSTransitionEnd", function() {
          return _this.toggleDrawer("close");
        });
      }
    };

    ConstructSlider.prototype.setupWindowResizer = function() {
      var _this = this;
      return window.onresize = function() {
        var $current, index, pxVal, viewportW;
        viewportW = _this.viewportWidth();
        $current = $(_this.container).find('.active');
        index = $(_this.inner).find('section').index($current);
        pxVal = (viewportW * index) * (90 / 100);
        return $(_this.inner).css('transform', "translateX(-" + pxVal + "px)");
      };
    };

    ConstructSlider.prototype.setupKeybindings = function() {
      var _this = this;
      $(window).focus(function() {
        var window_focus;
        return window_focus = true;
      });
      return $(window).keydown(function(event) {
        var arrow, keyCode;
        keyCode = event.keyCode || event.which;
        arrow = {
          left: 37,
          up: 38,
          right: 39,
          down: 40
        };
        switch (keyCode) {
          case arrow.left:
            return _this.slideNext("prev");
          case arrow.right:
            return _this.slideNext("next");
          case arrow.down:
            return _this.toggleDrawer();
          case arrow.up:
            return _this.toggleDrawer();
        }
      });
    };

    ConstructSlider.prototype.viewportWidth = function() {
      return document.documentElement.clientWidth;
    };

    return ConstructSlider;

  })();

  $(function() {
    return new ConstructSlider();
  });

}).call(this);