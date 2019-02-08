module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // Watch ----------------------------------
    watch: {
      css: {
        files: ['stylesheets/*.scss'],
        tasks: ['sass']
      },
      coffee: {
        files: ['js/*.coffee'],
        tasks: ['coffee']
      },
      // jekyll: {
			// 	files: ['*.html'],
			// 	tasks: ['jekyll:serve']
			// }
    },
    // Sass ------------------------------------
    sass: {
      dist: {
        options: {
          style: 'compressed'
        },
        files: {
          'stylesheets/application.css': 'stylesheets/application.scss'
        }
      }
    },
    // Coffee ---------------------------------
    coffee: {
      compile: {
        files: {
          'js/application.js': 'js/application.coffee',
        }
      },
    },
    // Jekyll ---------------------------------
    jekyll: {                             // Task
      options: {                          // Universal options
        bundleExec: false,
      },
      serve: {                            // Another target
        options: {
          config: '_config.yml',
          serve: true,
        }
      }
    }
  });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-jekyll');

  // Default task(s).
  grunt.registerTask('serve', ['jekyll:serve']);
  grunt.registerTask('compile', ['watch']);
  // grunt.registerTask('serve', function() {
  //
  //   grunt.task.run([
  //     'jekyll:serve',
  //     'watch'
  //   ]);
  // });
  //
};
