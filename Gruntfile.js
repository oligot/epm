module.exports = function(grunt) {

  grunt.initConfig({
    clean: {
      ise: ['EIFGENs'],
      ge: ['epm', 'epm.h', 'epm.sh', 'epm1*']
    },
    estudio: {
      main: {
      }
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

  require('matchdep').filterAll('grunt-*').forEach(grunt.loadNpmTasks);
  grunt.registerTask('default', ['clean:ise', 'compile:ise']);
  grunt.registerTask('ge', ['clean:ge', 'compile:ge']);
};
