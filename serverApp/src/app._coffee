express       = require 'express'
path          = require 'path'
favicon       = require 'serve-favicon'
logger        = require 'morgan'
cookieParser  = require 'cookie-parser'
bodyParser    = require 'body-parser'
routes        = require './routes/index'
app           = express()

# view engine setup
app.set 'views', path.join(__dirname, '../../clientApp/views')
app.set 'view engine', 'jade'

# uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use logger('dev')
app.use bodyParser.json()
app.use bodyParser.urlencoded(extended: false)
app.use cookieParser()
app.use express.static(path.join(__dirname, '../../clientApp/public'))
app.use '/', routes

# catch 404 and forward to error handler
app.use (req, res, next) ->
    err = new Error('Not Found')
    err.status = 404
    next err
    return

# error handlers

# development error handler
# will print stacktrace
if app.get('env') is 'development'
    app.use (err, req, res, next) ->
        res.status err.status or 500
        view = switch err.status
            when 404 then '404'
            else '500'
        res.render view, {
            message: err.message
            error: err
        }

# production error handler
# no stacktraces leaked to user
app.use (err, req, res, next) ->
    res.status err.status or 500
    view = switch err.status
            when 404 then '404'
            else '500'
    res.render view, {
        message: err.message
        error: {}
    }

module.exports = app
