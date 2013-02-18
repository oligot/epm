var spawn = require('child_process').spawn;

module.exports = function(grunt) {

  grunt.registerTask('compile', 'Eiffel compilation', function() {
    var done = this.async();

    process.env.EIFFEL_LIBRARY = process.cwd() + '/eiffel_library';
    process.env.GOBO = process.env.EIFFEL_LIBRARY + '/gobo';
    var ec = spawn('ec', ['-config', 'epm.ecf', '-finalize', '-c_compile']);

    ec.stdout.on('data', function (data) {
      process.stdout.write(data);
    });

    ec.stderr.on('data', function (data) {
      process.stdout.write(data);
    });

    ec.on('exit', function (code) {
      if (code === 0) {
        done();
      } else {
        done(false);
      }
    });
  });

  grunt.initConfig({
    clean: ['EIFGENs']
  });

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.registerTask('default', ['clean', 'compile']);
};
