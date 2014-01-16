
chai = require 'chai';
expect = chai.expect;

spd = require '../src/spd.js'

describe 'spd file pares',->
	it 'no parameter procedure', ->
		v = spd.parse "PROCEDURE PROCEDURENAME()->,=> FAR ;"
		console.log ">",v;
		expect(1).to.be.equal(2);

