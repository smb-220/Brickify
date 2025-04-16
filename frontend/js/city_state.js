var countries = Object();

// List of Indian states
countries['India'] = '|Andhra Pradesh|Arunachal Pradesh|Assam|Bihar|Chhattisgarh|Goa|Gujarat|Haryana|Himachal Pradesh|Jharkhand|Karnataka|Kerala|Madhya Pradesh|Maharashtra|Manipur|Meghalaya|Mizoram|Nagaland|Odisha|Punjab|Rajasthan|Sikkim|Tamil Nadu|Telangana|Tripura|Uttar Pradesh|Uttarakhand|West Bengal';

////////////////////////////////////////////////////////////////////////////

var city_states = Object();

// Indian states with cities (Note: Cities are just examples, you can add more as needed)
city_states['Andhra Pradesh'] = '|Hyderabad|Visakhapatnam|Vijayawada';
city_states['Maharashtra'] = '|Mumbai|Pune|Nagpur|Nashik';
city_states['Uttar Pradesh'] = '|Lucknow|Kanpur|Agra|Varanasi';
city_states['Tamil Nadu'] = '|Chennai|Coimbatore|Madurai|Salem';
city_states['West Bengal'] = '|Kolkata|Siliguri|Howrah|Durgapur';
city_states['Karnataka'] = '|Bengaluru|Mysuru|Hubballi|Mangaluru';
city_states['Rajasthan'] = '|Jaipur|Udaipur|Jodhpur|Kota';
city_states['Gujarat'] = '|Ahmedabad|Surat|Vadodara|Rajkot';
city_states['Kerala'] = '|Thiruvananthapuram|Kochi|Kozhikode|Kottayam';
city_states['Bihar'] = '|Patna|Gaya|Bhagalpur|Muzaffarpur';

//////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////

function setRegions()
{
	for (region in countries)
		document.write('<option value="' + region + '">' + region + '</option>');
}

function set_country(oRegionSel, oCountrySel, oCity_StateSel)
{
	var countryArr;
	oCountrySel.length = 0;
	oCity_StateSel.length = 0;
	var region = oRegionSel.options[oRegionSel.selectedIndex].text;
	if (countries[region])
	{
		oCountrySel.disabled = false;
		oCity_StateSel.disabled = true;
		oCountrySel.options[0] = new Option('SELECT COUNTRY','');
		countryArr = countries[region].split('|');
		for (var i = 0; i < countryArr.length; i++)
			oCountrySel.options[i + 1] = new Option(countryArr[i], countryArr[i]);
		document.getElementById('txtregion').innerHTML = region;
		document.getElementById('txtplacename').innerHTML = '';
	}
	else oCountrySel.disabled = true;
}

function set_city_state(oCountrySel, oCity_StateSel)
{
	var city_stateArr;
	oCity_StateSel.length = 0;
	var country = oCountrySel.options[oCountrySel.selectedIndex].text;
	if (city_states[country])
	{
		oCity_StateSel.disabled = false;
		oCity_StateSel.options[0] = new Option('SELECT NEAREST CITY','');
		city_stateArr = city_states[country].split('|');
		for (var i = 0; i < city_stateArr.length; i++)
			oCity_StateSel.options[i+1] = new Option(city_stateArr[i],city_stateArr[i]);
		document.getElementById('txtplacename').innerHTML = country;
	}
	else oCity_StateSel.disabled = true;
}

function print_city_state(oCountrySel, oCity_StateSel)
{
	var country = oCountrySel.options[oCountrySel.selectedIndex].text;
	var city_state = oCity_StateSel.options[oCity_StateSel.selectedIndex].text;
	if (city_state && city_states[country].indexOf(city_state) != -1)
		document.getElementById('txtplacename').innerHTML = city_state + ', ' + country;
	else document.getElementById('txtplacename').innerHTML = country;
}
