require! <[express gulp gulp-bower gulp-livescript gulp-concat gulp-uglify tiny-lr gulp-livereload]>

livereload-server = tiny-lr!
livereload-port = 35729
livereload = -> gulp-livereload livereload-server

gulp.task 'bower' ->
  gulp-bower!

gulp.task 'js:app' ->
  gulp.src 'app/**/*.ls'
    .pipe gulp-livescript bare: true
    .pipe gulp-concat 'app.js'
    .pipe gulp-uglify!
    .pipe gulp.dest '_public/js'
    .pipe livereload!

gulp.task 'css' ->
  gulp.src 'app/**/*.css'
    .pipe gulp-concat 'app.css'
    .pipe gulp.dest '_public/css/app.css'
    .pipe livereload!

gulp.task 'template' ->
  gulp.src 'app/**/*.html'
    .pipe gulp.dest '_public'
    .pipe livereload!

gulp.task 'build' <[bower js:app css template]> ->

gulp.task 'watch' ->
  livereload-server.listen livereload-port, ->
    gulp.watch ['app/**/*.ls'] <[js:app]>
    gulp.watch ['app/**/*.css'] <[css]>
    gulp.watch ['app/**/*.html'] <[template]>

gulp.task 'dev' <[build watch]> ->
  require! <[express]>
  port = 3000
  app = express!
    .use require('connect-livereload')!
    .use '/' express.static '_public'
  console.log "Running on http://localhost:#port"
  app.listen port

gulp.task 'default' <[dev]> ->
