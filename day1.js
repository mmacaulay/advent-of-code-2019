const lines = require('fs').readFileSync('./day1.txt', { encoding: 'utf8' }).split('\n')
const masses = lines.map(l => parseInt(l, 10))
const assert = require('assert')

function testFuelRequiredA () {
  assert(fuelRequiredA(12) === 2)
  assert(fuelRequiredA(14) === 2)
  assert(fuelRequiredA(1969) === 654)
  assert(fuelRequiredA(100756) === 33583)
}

function testFuelRequiredB () {
  assert(fuelRequiredB(14) === 2)
  assert(fuelRequiredB(1969) === 966)
}

function fuelRequiredA (mass) {
  return Math.floor(mass / 3) - 2
}

function fuelRequiredB (mass) {
  let fuel = 0
  let required = mass

  do {
    required = fuelRequiredA(required)
    if (required < 0) required = 0
    fuel += required
  } while (required > 0)

  return fuel
}

function day1A () {
  const totalFuelRequired = masses.reduce((fuel, mass) => {
    return fuel + fuelRequiredA(mass)
  }, 0)
  console.log('Total fuel required, A:', totalFuelRequired)
}

function day1B () {
  const totalFuelRequired = masses.reduce((fuel, mass) => {
    return fuel + fuelRequiredB(mass)
  }, 0)
  console.log('Total fuel required, B:', totalFuelRequired)
}

testFuelRequiredA()
testFuelRequiredB()
day1A()
day1B()