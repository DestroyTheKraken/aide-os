"""
Recreational Area Chatbot
A simple console-based chatbot demo for answering common guest questions.
"""

from typing import Dict, List


class RecreationalAreaChatbot:
    def __init__(self) -> None:
        self.responses: Dict[str, str] = {
            "hours": "The recreational area is open from 8:00 AM to 9:00 PM every day.",
            "tickets": "General admission is $12 for adults, $8 for children, and free for kids under 5.",
            "parking": "Parking is available near the main entrance for $5 per vehicle.",
            "events": "This weekend we have a fishing clinic, a family picnic day, and evening live music.",
            "weather": "Please check the local forecast before visiting. Some outdoor activities may close during storms.",
            "food": "We have a snack bar, picnic tables, and food trucks during larger events.",
            "staffing": "Staffing levels are adjusted based on expected attendance, weather, and special events.",
        }

    def get_response(self, user_message: str) -> str:
        text = user_message.lower().strip()

        # Merged Code from build 33
        if "hello" in text or "hi" in text:
            return "Hello! Welcome to the recreational area assistant. How can I help you today?"

        if "hour" in text or "open" in text or "close" in text:
            return self.responses["hours"]

        if "ticket" in text or "price" in text or "cost" in text:
            return self.responses["tickets"]

        if "park" in text or "parking" in text:
            return self.responses["parking"]

        if "event" in text or "festival" in text or "activity" in text:
            return self.responses["events"]

        if "weather" in text or "rain" in text or "storm" in text:
            return self.responses["weather"]

        if "food" in text or "eat" in text or "snack" in text:
            return self.responses["food"]

        if "staff" in text or "attendance" in text or "busy" in text:
            return self.responses["staffing"]

        if "bye" in text or "goodbye" in text:
            return "Goodbye! We hope to see you at the recreational area soon."

        return (
            "I can help with hours, tickets, parking, events, weather, food, and staffing. "
            "Please ask a question about one of those topics."
        )


def run_chatbot() -> None:
    bot = RecreationalAreaChatbot()

    print("Recreational Area Chatbot")
    print("Type 'bye' to exit.\n")

    while True:
        user_input = input("You: ").strip()
        if not user_input:
            print("Bot: Please enter a question.")
            continue

        response = bot.get_response(user_input)
        print(f"Bot: {response}")

        if "bye" in user_input.lower():
            break


if __name__ == "__main__":
    run_chatbot()
