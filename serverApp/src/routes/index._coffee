express = require 'express'
router = express.Router()

router.get '/', (req, res) ->
    res.render 'example', { title: 'Express' }

module.exports = router
