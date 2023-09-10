//
//  main.swift
//  test
//
//  Created by Tyler Zhao on 9/1/23.
//

import Foundation

enum diceOutcome {
	case success
	case failure
}

struct Event {
	let id: String
	let description: String
	let choices: [Choice]
	let aciiImage: String
	var diceRollRequired: Bool
}

struct Choice {
	let text: String
	let nextScene: String
	let failureScene: String
	
	init(text: String, nextScene: String, failureScene: String = "failure") {
		self.text = text
		self.nextScene = nextScene
		self.failureScene = failureScene
	}
}


class Adventure {
	
	private var currentEvent: Event
	private var isAlive = true
	
	init(currentEvent: Event){
		self.currentEvent = currentEvent
	}
	
	func gameStart() {
		
		while true {
			if isAlive == false {
				print("Thank you for playing, Press enter to restart")
				let _ = readLine()
				if let validEvent = events["start"] {
					currentEvent = validEvent
				}
				isAlive = true
			}
			
			displayGame()
			if !currentEvent.choices.isEmpty {
				let choiceIndex = getUserChoice() - 1
				let currentScene = currentEvent.choices[choiceIndex]
				let nextScene = currentScene.nextScene
				let failureScene = currentScene.failureScene
				
				if let next = events[nextScene] {
					if currentEvent.diceRollRequired == true {
						switch rollDice() {
						case .success:
							currentEvent = next
						case.failure:
							//isAlive = false
							if let failNext = events[failureScene] {
								currentEvent = failNext
							}
						}
					} else {
						currentEvent = next
					}
				}
			} else {
				isAlive = false
			}
		}
	}
	
	private func displayGame() {
		if let imageArt = loadASCIIImage(filename: currentEvent.aciiImage) {
			print(imageArt)
		}
		print(currentEvent.description)
		for (index, choice) in currentEvent.choices.enumerated() {
			print("\(index + 1). \(choice.text)")
		}
		
		if !currentEvent.choices.isEmpty {
			print("Enter the number of your choice: ")
		}
	}
	
	private func getUserChoice() -> Int {
		while true {
			if let choiceString = readLine(), let choiceIndex = Int(choiceString),
				choiceIndex >= 1 && choiceIndex <= currentEvent.choices.count {
				return choiceIndex
			} else {
				print("Please enter a valid choice number.")
			}
		}
	}
	
	private func rollDice() -> diceOutcome {
		let roll = Int.random(in: 1...20)
		print("You rolled a \(roll)")
		return roll > 5 ? .success: .failure
	}
	
	private func loadASCIIImage(filename: String) -> String? {
		guard !filename.isEmpty else  { return nil }
		
		guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
			print("file not found")
			return nil
		}
		
		do {
			return try String(contentsOfFile: path, encoding: .utf8)
		} catch {
			print("Error loading image")
			return nil
		}
	}
}

var events: [String: Event] = [
	"start": Event(id: "start",description: "You suddently wake up to a loud noice, you find yourself disoriented, as your alien pod opens up revieling your surroundings",choices: [
		Choice(text: "Explore the ship, look for a way out.",nextScene: "explore"),
		Choice(text: "Stay in your pod wait for help to arrive",nextScene: "wait")], aciiImage: "startImage", diceRollRequired: false),
	"explore": Event(id: "explore", description: "You hop out of your pod notice that the ship is under attack you need to immediately find a way out", choices: [
		Choice(text: "Turn right", nextScene: "right"),
		Choice(text: "Turn left ", nextScene: "left"),
	], aciiImage: "leftRight", diceRollRequired: false),
	"wait": Event(id: "wait", description: "Your pod suddently closes up, fumes fill up your pod giving you a slow and suffocating death", choices: [], aciiImage: "gameOver", diceRollRequired: false),
	"right": Event(id: "right", description: "Its a dead end", choices: [
		Choice(text: "Turn back", nextScene: "explore"),
	], aciiImage: "", diceRollRequired: false),
	"left": Event(id: "left", description: " You go through a narrow pathway where you find the entrance to the ship's cockpit", choices: [
		Choice(text: "Enter the cockpit", nextScene: "cockpit"),
		Choice(text: "Turn back", nextScene: "explore")
	], aciiImage: "tunnel", diceRollRequired: false),
	"cockpit": Event(id: "cockpit", description: "You find the ship's captain, the demon king startled by your presense attacks you", choices: [
		Choice(text: "Counter ", nextScene: "counter", failureScene: "dodgeFailed"),
		Choice(text: "Dodge", nextScene: "dodge", failureScene: "counterFailed")
	], aciiImage: "bossImage", diceRollRequired: true),
	"counter": Event(id: "counter", description: "You swiftly counter his attack giving you an opportunity to finish him off", choices: [
		Choice(text: "kill ", nextScene: "kill"),
		Choice(text: "spare", nextScene: "spare")
	], aciiImage: "diceImage", diceRollRequired: false),
	"dodge": Event(id: "dodge", description: "You succesfuly dodge, giving you opportunity to attack", choices: [
		Choice(text: "Attack ", nextScene: "kill"),
		Choice(text: "spare", nextScene: "spare")
	], aciiImage: "diceImage", diceRollRequired: false),
	"kill": Event(id: "kill", description: "The monster dies in one shot, as you escape you find yourself in another world", choices: [], aciiImage: "winGame", diceRollRequired: false),
	"spare": Event(id: "spare", description: "You spared the monster, the monster takes advantage of you kindness slicing you in half", choices: [], aciiImage: "gameOver", diceRollRequired: false),
	"dodgeFailed": Event(id: "dodgeFailed", description: "You failed to dodge the monster's attack, allowing the monster to slice you in half", choices: [], aciiImage: "gameOver", diceRollRequired: false),
	"counterFailed": Event(id: "counterFailed", description: "You Failed to counter, allowing the monster to slice you in half", choices: [], aciiImage: "gameOver", diceRollRequired: false),
]


let game = Adventure(currentEvent: events["start"]!)
game.gameStart()

