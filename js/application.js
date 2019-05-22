(function() {
  var ConstructSlider;

  ConstructSlider = class ConstructSlider {
    constructor() {
      // @nav       = document.getElementsByClassName('slider-nav')[0]
      // @sections  = @inner.getElementsByTagName('section')
      this.navWork = document.getElementById('nav-work');
      this.navAbout = document.getElementById('nav-about');
      this.pathname = window.location.pathname;
      this.setInnerWidth();
    }

    setInnerWidth() {
      if (this.pathname === "/about") {
        console.log("about");
        this.navAbout.classList.add('active');
        return this.navWork.classList.remove('active');
      } else {
        console.log("work");
        this.navAbout.classList.remove('active');
        return this.navWork.classList.add('active');
      }
    }

  };

  $(function() {
    return new ConstructSlider();
  });

}).call(this);
