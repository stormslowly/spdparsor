
chai = require 'chai';
expect = chai.expect;

spd = require '../src/spd.js'

describe 'spd file pares',->
	it 'no parameter procedure', ->
		p = spd.parse "PROCEDURE PROCEDURENAME()->,FAR => ;"
		p = p[0];
		expect(p).to.have.deep.property('name', 'PROCEDURENAME');

		# console.log ">",v;

	it 'parese one parameter procedure', ->
		p = spd.parse "PROCEDURE p2(IN input1 type1)->,FAR => ;"
		p = p[0];
		expect(p).to.have.property('name','p2');
		expect(p.parameters).to.eql([{dir:'in',name:'input1',type:'type1'}]);

		p = spd.parse "PROCEDURE p2(OUT input2 type2)->,FAR => ;"
		p = p[0];
		expect(p).to.have.property('name','p2');
		expect(p.parameters).to.eql([{dir:'out',name:'input2',type:'type2'}]);

	it 'parse two parameters procedure', ->
		p = spd.parse "PROCEDURE p1(IN input1 type1,OUT out2 type2)->,FAR => ;"
		p = p[0];
		expect(p).to.have.property('name','p1');
		expect(p.parameters).to.deep.equal(
			[{dir:'in' ,name:'input1',type:'type1'},
			 {dir:'out',name:'out2'  ,type:'type2'}]);

		p = spd.parse "PROCEDURE p2(IN input1 type1,IN input2 type2)->,FAR => ;"
		p = p[0];
		expect(p).to.have.property('name','p2');
		expect(p.parameters).to.eql([{dir:'in' ,name:'input1',type:'type1'},
			                           {dir:'in' ,name:'input2',type:'type2'}]);

	it 'parse multi procedures ', ->

		expect([1,2,3]).to.deep.equal([1,2,3]);

		ps = spd.parse "PROCEDURE p1()->,FAR =>  ; 
		                 PROCEDURE p2()->, FAR => ;
		                 PROCEDURE p3(IN input1 type1) ->, FAR => ;"

		expect(ps.length).to.equal(3);
		expect(ps).to.deep.equal([{name:'p1'},{name:'p2'},
			{name:'p3',parameters:[{dir:'in',name:'input1',type:'type1'}]}])

	it 'parse the procedure with comment'

	it 'ignore slash start comment ', ->
		p = spd.parse('/* comment 1
			                comment 2
			              */
			            PROCEDURE P1()->,FAR => ;');


