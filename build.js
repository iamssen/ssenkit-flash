var Flbuild = require('flbuild')
    , exec = require('done-exec')

var flbuild = new Flbuild()
flbuild.setEnv('FLEX_HOME')
flbuild.setEnv('PROJECT_HOME', '.')
flbuild.setEnv('PLAYER_VERSION', '14.0')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/player/$PLAYER_VERSION')
flbuild.addExternalLibraryDirectory('$FLEX_HOME/frameworks/libs/')
flbuild.addLibraryDirectory('$FLEX_HOME/frameworks/locale/en_US/')
flbuild.addLibraryDirectory('$PROJECT_HOME/libs/')
flbuild.addSourceDirectory('$PROJECT_HOME/src')

var ssenkit = flbuild.getLibraryCreator()
ssenkit.setFilterFunction(function(file) {
    return file.class.indexOf('ssen.') === 0
})
ssenkit.createBuildCommand('$PROJECT_HOME/bin/ssenkit.swc', function(cmd) {
    console.log(cmd)
    exec(cmd).run(function() {console.log('complete build ./bin/ssenkit.swc')})
})