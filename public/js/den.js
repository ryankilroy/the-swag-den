function run(n) {
	var num = Number(n%5);
	var title = document.getElementById("title");
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
				title.style.color = 'gold';
				break;
			case 4:
				title.style.color = 'white';
				break;
		}
	}
	setTimeout(function(){
		//console.log(num+1);
		run(num+1);
	}, 2000);
}

function countdown() {

	setTimeout(function(){

		var endtime = 'October 01 2016 20:30:00 GMT-0400';
		var time = getTimeRemaining(endtime);

		var hours = document.getElementsByClassName("hours");
		var minutes = document.getElementsByClassName("minutes");
		var seconds = document.getElementsByClassName("seconds");

		hours[0].innerHTML = time.hours;
		minutes[0].innerHTML = time.minutes;
		seconds[0].innerHTML = time.seconds;
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
