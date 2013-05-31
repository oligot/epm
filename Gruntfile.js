var path = require('path');

module.exports = function(grunt) {

  grunt.initConfig({
    clean: {
      ise: ['EIFGENs'],
      ge: ['epm', 'epm.h', 'epm.sh', 'epm1*']
    },
    compile: {
      ise: {
        options: {
          compiler: 'ise'
        }
      },
      ge: {
        options: {
          compiler: 'ge'
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-eiffel');
  grunt.registerTask('default', ['clean:ise', 'compile:ise']);
  grunt.registerTask('ge', ['clean:ge', 'compile:ge']);
};
