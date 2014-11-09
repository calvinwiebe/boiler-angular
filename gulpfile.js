var gulp = require('gulp');
var streamline = require('gulp-streamlinejs');
var browserify = require('browserify');
var watchify = require('uber-watchify');
var source = require('vinyl-source-stream');
var path = require('path');
var fs = require('fs');
var watch = require('gulp-watch');
var gutil = require('gulp-util');

gulp.task('build:serverApp', function() {
    gulp.src('serverApp/src/**/*._coffee')
        .pipe(streamline())
        .pipe(gulp.dest('./serverApp/lib'));
});

var bundles = fs.readdirSync('clientApp/src/bundles');

gulp.task('build:browserify', function() {
    var bundle = function(name, w) {
        var stream = w.bundle();
        if (!stream) return;
        stream
        .pipe(source(name + '.js'))
        .pipe(gulp.dest('clientApp/public/js'))
        .on('end', function() {
            w.write();
        });
    };

    bundles.forEach(function(name) {
        var entryPoint = path.resolve('clientApp/src/bundles/' + name + '/index.js'),
        cacheFile = path.resolve('clientApp/.cache/' + name + '.json'),
        w = watchify(browserify({
            debug: false,
            cache: watchify.getCache(cacheFile),
            packageCache: {},
            fullPaths: true,
            entries: [entryPoint]
        }), {
          watch: false,
          cacheFile: cacheFile
        });
        bundle(name, w);
    });
})

gulp.task('build:clientApp', ['build:browserify']);

gulp.task('build', ['build:serverApp', 'build:clientApp']);
