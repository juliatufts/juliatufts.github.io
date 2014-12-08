;(function() {
	var voiceGenerator = function(formId, textId) {
		this.form = document.getElementById(formId);
		this.textInput = document.getElementById(textId);
		this.ready = false;
		var self = this;

		this.form.onsubmit = function(e) {
			e.preventDefault();					// don't refresh the page on enter key press
			if (self.ready) {
		    	self.speak(self.textInput.value.toString());
			}
		};

		// wait until the voices are loaded
		window.speechSynthesis.onvoiceschanged = function() {
		    var voices = window.speechSynthesis.getVoices(); 	// 33 Zarvox, 28 Trinoids
		    self.voice = voices[33];
		    self.ready = true;
		};
	};

	voiceGenerator.prototype = {
		speak : function(input) {
			var sentences = input.split(/[.,\;\:\?\!]/);
			for (var i = 0; i < sentences.length; i++) {
				this.saySentence(sentences[i]);
			}
		},

		saySentence : function(input) {
			var words = input.split(' ');
			var lastWord = "";

			if (words.length <= 1) {
				this.saySubSentence(input, 1, 1);
			} else {
				// split the sentence just before the last word
				var splitInput = this.splitSentence(input);
				var firstHalf = splitInput[0];
				var secondHalf = splitInput[1];
				
				// say the first half and then the last word
				this.saySubSentence(firstHalf, 1, 1);

				// choose a pitch higher or lower for the last word
				var pitch = [0.8, 1.6][Math.floor(Math.random() * 2)];
				this.saySubSentence(secondHalf, pitch, 1);
			}
		},

		saySubSentence : function(subSentence, pitch, rate) {
			var wesleyRegex = /(w+e+s+l+e+y+)/;

			// if the subsentence contains WESLEY, split the subsentence by WESLEY occurences
			if (wesleyRegex.test(subSentence)) {
				var lines = subSentence.split(wesleyRegex);
				for (var i = 0; i < lines.length; i++) {
					var msg = new SpeechSynthesisUtterance();
					msg.text = lines[i];
					msg.pitch = pitch;
					msg.voice = this.voice;
					msg.rate = rate;

					// check if the word is any variation of WESLEY
					if (wesleyRegex.test(lines[i])) {
						msg.text = "wesley";
						msg.pitch = 0.8;
						msg.rate = 0.1;
					}

					speechSynthesis.speak(msg);
				}
			} else {
				var msg = new SpeechSynthesisUtterance();
				msg.text = subSentence;
				msg.pitch = pitch;
				msg.voice = this.voice;
				msg.rate = rate;
				speechSynthesis.speak(msg);
			}
		},

		splitSentence : function(input) {
			var words = input.split(' ');
			var firstHalf = words.slice(0, words.length - 1).join(" ");
			var secondHalf = words[words.length - 1];
			return [firstHalf, secondHalf];
		}
	};

	window.onload = function() {
		new voiceGenerator("formId", "textId");
	};
})();
