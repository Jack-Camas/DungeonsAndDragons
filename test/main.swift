//
//  main.swift
//  test
//
//  Created by Tyler Zhao on 9/1/23.
//

import Foundation

struct Event {
	let id: String
	let description: String
	let choices: [Choice]
	let aciiImage: String
}

struct Choice {
	let text: String
	let nextScene: String
}


class Adventure {
	
	private var currentEvent: Event
	private var isAlive = true
	
	init(currentEvent: Event){
		self.currentEvent = currentEvent
	}
	
	func gameStart() {
		displayGame()
		var choiceIndex = getUserChoice() - 1
		var currentScene = currentEvent.choices[choiceIndex]
		var nextScene = currentScene.nextScene
		
		if let next = events[nextScene] {
			currentEvent = next
			gameStart()
		} else {
			print("Invalid Event")
		}
		
		//		if currentChoice.nextScene == "counter" {
		//			rollDice()
		//		}
		
//		if nextSceneID == "wait" {
//			isAlive = false
//			if let imageArt = loadASCIIImage(filename: currentEvent.aciiImage) {
//				print(imageArt)
//			}
//			print("Game over")
//			return
//		}
	}
	
	private func displayGame() {
		if let imageArt = loadASCIIImage(filename: currentEvent.aciiImage) {
			print(imageArt)
		}
		print(currentEvent.description)
		for (index, choice) in currentEvent.choices.enumerated() {
			print("\(index + 1). \(choice.text)")
		}
		print("Enter the number of your choice: ")
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
	
	private func rollDice() -> String {
		let roll = Int.random(in: 1...20)
		print("You rolled a \(roll)")
		return roll < 5 ? "dodge": "counter"
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
		Choice(text: "Stay in your pod wait for help to arrive",nextScene: "wait")], aciiImage: "startImage"),
	"explore": Event(id: "explore", description: "You hop out of your pod notice that the ship is under attack you need to immediately find a way out", choices: [
		Choice(text: "Turn left ", nextScene: "left"),
		Choice(text: "Turn right", nextScene: "right")
	], aciiImage: ""),
	"wait": Event(id: "wait", description: "Your pod suddently closes up, fumes fill up your pod giving you a slow and suffocating death", choices: [], aciiImage: "gameOver"),
	"right": Event(id: "right", description: "Its a dead end", choices: [
		Choice(text: "Turn back", nextScene: "explore"),
	], aciiImage: ""),
	"left": Event(id: "left", description: " You go through a narrow pathway where you find the entrance to the ship's cockpit", choices: [
		Choice(text: "Enter the cockpit", nextScene: "cockpit"),
		Choice(text: "Turn back", nextScene: "explore")
	], aciiImage: ""),
	"cockpit": Event(id: "cockpit", description: "You find the ship's captain, a vile monster statled by your presence immdediately attacks you", choices: [
		Choice(text: "Counter ", nextScene: "counter"),
		Choice(text: "Dodge", nextScene: "dodge")
	], aciiImage: "bossImage"),
	"counter": Event(id: "counter", description: "You swiftly counter his attack giving you an opportunity to finish him off", choices: [
		Choice(text: "kill ", nextScene: "kill"),
		Choice(text: "spare", nextScene: "spare")
	], aciiImage: "diceImage"),
	"dodge": Event(id: "dodge", description: "You failed to dodge allowing the monster to slice you in half", choices: [
	], aciiImage: ""),
	"kill": Event(id: "kill", description: "You kill the create in one shot, allowin g ", choices: [], aciiImage: ""),
	"spare": Event(id: "spare", description: "You spared the monster, the monster takes advantage of you kindness piercin his sword agains your herat", choices: [], aciiImage: ""),
]


let game = Adventure(currentEvent: events["start"]!)
game.gameStart()

