var Flbuild = require('flbuild')
    , exec = require('done-exec')
    , gulp = require('gulp')

var flbuild = new Flbuild()
flbuild.setEnv('FLEX_HOME')
flbuild.setEnv('PROJECT_HOME', '.')
flbuild.setEnv('PLAYER_VERSION', '14.0')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
flbuild.addLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
flbuild.addLibraryDirectory('$PROJECT_HOME/libs/')
flbuild.addSourceDirectory('$PROJECT_HOME/src')

gulp.task('ssenkit', function(done) {
	var build = flbuild.getLibraryCreator()
	build.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')

	build.setFilterFunction(function(file) {
		return file.class.indexOf('ssen.') === 0
	})

	build.createBuildCommand('$PROJECT_HOME/bin/ssenkit.swc', function(cmd) {
		console.log(cmd)
    	exec(cmd).run(done)
	})
})

gulp.task('test', function(done) {
	var build = flbuild.getApplicationCreator()
	build.addLibraryDirectory('$FLEX_HOME/frameworks/libs/')

	build.createBuildCommand('$PROJECT_HOME/src-incubator/HeaderWork.mxml', '$PROJECT_HOME/bin/HeaderWork.swf', function(cmd) {
		console.log(cmd)
		exec(cmd).run(done)
	})
})