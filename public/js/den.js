function run(n) {
	var num = Number(n%5);
	var title = document.getElementById("title");
	var strokeWidth = "0.25vw";
	//console.log(title);
	if (title){
		//console.log(num);
		switch (num) {
			case 0:
				title.style.color = "orange";
				break;
			case 1:
				title.style.color = 'red';
				break;
			case 2:
				title.style.color = 'green';
				break;
			case 3:
				title.style.color = 'yellow';
				break;
			case 4:
				title.style.color = 'transparent';
				strokeWidth = "0px";
				break;
		}
		title.style.webkitTextStrokeWidth = strokeWidth;
	}
	setTimeout(function(){
		//console.log(num+1);
		run(num+1);
	}, 2000);
}

function countdown() {

	setTimeout(function(){

		var endtime = 'October 01 2016 21:00:00 GMT-0400';
		var time = getTimeRemaining(endtime);
		if (time.days < 1 && time.hours < 1 && time.minutes < 1 && time.seconds < 1) {
			window.location.href = "/countdone";
		}
		var hours = document.getElementsByClassName("hours")[0];
		var minutes = document.getElementsByClassName("minutes")[0];
		var seconds = document.getElementsByClassName("seconds")[0];

		if (time.hours + time.days*24 < 1 && hours.className.indexOf("blink") == -1){
			hours.className += " blink";
			minutes.className += " blink";
			seconds.className += " blink";
		}
		hours.innerHTML = time.hours + time.days*24;
		if (time.hours + time.days*24 < 10){
			hours.innerHTML = '0' + hours.innerHTML;
		}
		minutes.innerHTML = time.minutes;
		if (time.minutes < 10){
			minutes.innerHTML = '0' + minutes.innerHTML;
		}

		seconds.innerHTML = time.seconds;
		if (time.seconds < 10){
			seconds.innerHTML = '0' + seconds.innerHTML;
		}
		//hours[1].innerHTML = time.hours;
		//minutes[1].innerHTML = time.minutes;
		//seconds[1].innerHTML = time.seconds;

		countdown();

	}, 1000);
}

function getTimeRemaining(endtime){
  var t = Date.parse(endtime) - Date.parse(new Date());
  var seconds = Math.floor( (t/1000) % 60 );
  var minutes = Math.floor( (t/1000/60) % 60 );
  var hours = Math.floor( (t/(1000*60*60)) % 24 );
  var days = Math.floor( t/(1000*60*60*24) );
  return {
    'total': t,
    'days': days,
    'hours': hours,
    'minutes': minutes,
    'seconds': seconds
  };
}
