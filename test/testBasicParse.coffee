
chai = require 'chai';
expect = chai.expect;

spd = require '../src/spd.js'

describe 'spd file parsor',->
  it 'can parse no parameter procedure without comment', ->
    p = spd.parse "PROCEDURE PROCEDURENAME()->,FAR => ;"
    p = p[0];
    expect(p).to.have.deep.property('name', 'PROCEDURENAME');

  it 'can parse no parameter PROCEDURE with comment', ->
    p = spd.parse " PROCEDURE p1()-> , FAR => COMMENT 'test comment' ;"

  it 'can parse one parameter procedure', ->
    p = spd.parse "PROCEDURE p2(IN input1 type1)->,FAR => ;"
    p = p[0];
    expect(p).to.have.property('name','p2');
    expect(p.parameters).to.eql([{dir:'in',name:'input1',type:'type1'}]);

    p = spd.parse "PROCEDURE p2(OUT input2 type2)->,FAR => ;"
    p = p[0];
    expect(p).to.have.property('name','p2');
    expect(p.parameters).to.eql([{dir:'out',name:'input2',type:'type2'}]);

  it 'can parse two parameters procedure', ->
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

  it 'can parse multi procedures ', ->

    ps = spd.parse "PROCEDURE p1()->,FAR =>  ;
                     PROCEDURE p2()->, FAR => COMMENT '#comment it' 'comment2 ';
                     PROCEDURE p3(IN input1 type1) ->, FAR => COMMENT 'comment3';"
    expect(ps.length).to.equal(3);
    expect(ps).to.deep.equal([
      {name:'p1',return:'',parameters:[]},
      {name:'p2',return:'',parameters:[]},
      {name:'p3',return:'',parameters:[{dir:'in',name:'input1',type:'type1'}]}])

  it 'can parse the procedure with COMMENT statement',->
    p = spd.parse "PROCEDURE PROCEDURENAME()->,FAR => COMMENT 'this is comment'
                                                              'this is comment2';"
    expect(p).to.have.deep.equal([{
      name:'PROCEDURENAME',
      return:'',
      parameters:[]}]);

    p = spd.parse "PROCEDURE PROCEDURENAME(IN input1 dword)->,FAR => COMMENT 'this is comment'
                                                              'this is comment2';"
    expect(p).to.have.deep.equal([{name:'PROCEDURENAME',return:'',parameters:[
                                  {dir:'in',name:'input1',type:'dword'} ]}]);

  it 'ignore slash star style comment ', ->
    p = spd.parse('/* comment 1
                      comment 2
                    */
                  PROCEDURE P1(/* test comment*/)->,FAR => ;');
    expect(p).to.deep.equal([{name:'P1',return:'',parameters:[]}]);

  it 'can parse no PROCEDURE leading defination',->
    procedures = spd.parse ('p1()->error_t,FAR=>;');
    expect(procedures).to.deep.equal([
      {name:'p1',
      return:'error_t',
      parameters:[]}]);

  it 'should support apparagx.spd',->
    procedures = spd.parse(" VIEWED FAR nw_element nw_elem_t
          COMMENT '#function=viewed__nw_element';");
    x = spd.parse("
      VIEWED FAR nw_element nw_elem_t
                  COMMENT '#function=viewed__nw_element';
      VIEWED FAR  system_type                 system_type_t,
                    wdisk_read_after_write      boolean;");
    expect(x).to.deep.equal([{
      'nw_element':'nw_elem_t'
      },
      {
        'system_type':'system_type_t',
        'wdisk_read_after_write':'boolean'
        }])

  it 'should support CONSTANT define',->
    p = spd.parse("CONSTANT
        asylib_defined = test,
        nextlib       = 3433;");

  it 'should support IN can ommitted in cdprtagx.spd',->
    procedures = spd.parse('PROCEDURE p(para error_t)->ret,FAR=>;');
    expect(procedures).to.deep.equal([
      {
        name:'p',return:'ret',
        parameters:[{dir:'in',name:'para',type:'error_t'}]
        }]);
  it 'should support typedefine in clugengx.spd'
  it 'should support FAR ommit => in ethlibgx',->
    procedures = spd.parse(" pro () -> error_t, FAR
                            COMMENT '#E: Initialize lib. ' ;")
    expect(procedures).to.deep.equal([{
      name:'pro',return:'error_t',
      parameters:[]
      }])
  it 'should support FAR <= in fixlibgx',->
    procedures = spd.parse(' p1(IN para1 dword)->,FAR <=;');
    expect(procedures).to.deep.equal([
      {
        name:'p1',return:'',
        parameters:[{dir:'in',name:'para1',type:'dword'}]
      }]);

  it 'should support NO libary libname in idwlibgx',->
    procedures = spd.parse("
      SERVICES SYNC
      get_sth (
        IN      io_unit     unit_it_t,
        IN      comp        unit_it_t,
        IN/OUT  curr_state  unit_state_t,
        IN/OUT  orig_state  unit_state_t,
        IN/OUT  state_info  io_unit_info_t
      ) -> error_t  /* success of operation */
      , FAR =>;");

  it 'should support ... in syklib',->
    procedures = spd.parse(' PROCEDURE p1(IN format string_t,...)->,FAR =>;');
