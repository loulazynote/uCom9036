window.chartColors = {
  red: 'rgb(255, 99, 132)',
  orange: 'rgb(255, 159, 64)',
  yellow: 'rgb(255, 205, 86)',
  green: 'rgb(75, 192, 192)',
  blue: 'rgb(54, 162, 235)',
  purple: 'rgb(153, 102, 255)',
  grey: 'rgb(231,233,237)'
};

window.chartColorsAry = [
    chartColors.red,
    chartColors.orange, 
    chartColors.yellow,
    chartColors.green,
    chartColors.blue,
    chartColors.purple,
    chartColors.grey
];

window.randomScalingFactor = function () {
    return  Math.round(Math.random() * 100);
};

window.GetRandomNumbers = function (number) {
    var ary = new Array();
    for (var i = 0; i < number; i++) {
        ary.push(randomScalingFactor());
    }
    return ary;
};
window.GetColors = function (number) {
    var ary = new Array();
    for (var i = 0; i < number; i++) {
        ary.push(window.chartColorsAry[i]);
    }
    return ary;
};
window.GetRandomColors = function (number) {
  var ary = new Array();
  for (var i = 0; i < number; i++) {
    ary.push(window.chartColorsAry[Math.round(Math.random() * 7) + 1]);
  }
  return ary;
};
