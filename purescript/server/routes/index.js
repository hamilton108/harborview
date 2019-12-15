var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('index', { title: "2D Graphics Demo" });
});

router.get('/rox', function (req, res, next) {
  res.json({ a: "Fox", b: { c: "dux" } });
});

router.get('/risclines/:ticker', function (req, res, next) {
  res.json({ be: 12.4, risc: 10.0, ask: 11.0, optionPrice: 23.0, stockPrice: 124.9 });
});

module.exports = router;
