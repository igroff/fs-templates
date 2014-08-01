var gulp = require('gulp');

var coffee      = require('gulp-coffee');
var concat      = require('gulp-concat');
var uglify      = require('gulp-uglify');
var imagemin    = require('gulp-imagemin');
var sourcemaps  = require('gulp-sourcemaps');
var combine     = require('stream-combiner');

var paths = {
  coffeeScripts: ['src/**/*.coffee', 'lib/**/*.coffee'],
  javascripts: ['src/**/*.js', 'lib/**/*.js'],
};

gulp.task('scripts', [], function() {
  // Minify and copy all JavaScript (except vendor scripts)
  // with sourcemaps all the way down
    var scripts = combine(
      gulp.src(paths.coffeeScripts).pipe(sourcemaps.init()).pipe(coffee()).pipe(uglify()),
      gulp.src(paths.javascripts).pipe(sourcemaps.init()).pipe(uglify())
    )
    scripts.on('error', function(e){ console.warn(e.message); });
    return scripts
    .pipe(concat('all.min.js'))
    .pipe(sourcemaps.write())
    .pipe(gulp.dest('build_output/js'));
});


// The default task (called when you run `gulp` from cli)
gulp.task('default', ['scripts']);

