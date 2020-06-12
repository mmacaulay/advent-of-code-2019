const rawInputs = require('fs')
  .readFileSync('./day2.txt', { encoding: 'utf8' })
  .split(',')
  .map(x => parseInt(x, 10))

const assert = require('assert')

function testRunProgram () {
  assert(arraysEqual(runProgram(5, [1,0,0,0,99]), [1,0,0,0,99]))
  assert(arraysEqual(runProgram(0, [99]), [99]))
  assert(arraysEqual(runProgram(0, [1,0,0,0,99]), [2,0,0,0,99]))
  assert(arraysEqual(runProgram(0, [2,3,0,3,99]), [2,3,0,6,99]))
  assert(arraysEqual(runProgram(0, [2,4,4,5,99,0]), [2,4,4,5,99,9801]))
  assert(arraysEqual(runProgram(0, [1,1,1,4,99,5,6,0,99]), [30,1,1,4,2,5,6,0,99]))
}

function testArraysEqual () {
  assert(arraysEqual([1,0,0,0,99], [1,0,0,0,99]))
  assert(!arraysEqual([1,0,0,0,99], [2,0,0,0,99]))
}

function arraysEqual (a1, a2) {
  return JSON.stringify(a1) === JSON.stringify(a2)
}

function runProgram (cursor, inputs) {
  if (cursor >= inputs.length) return inputs

  const opcode = inputs[cursor]
  if (opcode === 99) return inputs

  const input1 = inputs[inputs[cursor + 1]]
  const input2 = inputs[inputs[cursor + 2]]
  const position = inputs[cursor + 3]
  switch (opcode) {
    case 1:
      inputs[position] = input1 + input2
      break
    case 2:
      inputs[position] = input1 * input2
      break
    default:
      throw new Error('Unexpected opcode: ' + opcode)
  }
  return runProgram(cursor + 4, inputs)
}

function day2A () {
  const inputs = rawInputs.slice()
  inputs[1] = 12
  inputs[2] = 2
  const result = runProgram(0, inputs)
  console.log(result[0])
}

function day2B () {
  for (let noun = 0; noun < 100; noun++) {
    for (let verb = 0; verb < 100; verb++) {
      let inputs = rawInputs.slice()
      inputs[1] = noun
      inputs[2] = verb
      const result = runProgram(0, inputs)
      if (result[0] === 19690720) {
        return console.log(100 * noun + verb)
      }
    }
  }
}

testArraysEqual()
testRunProgram()
day2A()
day2B()