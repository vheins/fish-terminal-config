oh-my-posh init fish --config $HOME/.poshthemes/montys.omp.json | source
if status is-interactive
    # Commands to run in interactive sessions can go here
end
function fish_greeting
    echo "👋 Have a nice day, $USER."
    echo "🚀 Everything is up and running smoothly. How can I help you today?"
    echo "✨ Have a question? Just type \`jarvis '[your question]'\` to get an answer using Generative AI."
    echo "⚡ Ready to process your commands!"

end

function jarvis
    set -l query $argv
    set -l api_key "YOUR_GEMINI_API_KEY"  # Replace with your actual API key
    set -l api_url "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$api_key"

    # Make the API request and parse the JSON response
    set -l response (curl -s -H 'Content-Type: application/json' \
        -d '{"contents":[{"parts":[{"text":"'$query'"}]}]}' \
        -X POST $api_url)

    # Extract the relevant text from the JSON response
    set -l result (echo $response | jq ".candidates[0].content.parts[0].text")
    # Format the extracted text to apply bold and italic styles

    # Display the formatted result
    set result (string trim -c '"' $result)
    echo -e $result | sed  -e 's/\\\"/"/g' | glow -
end

function fish_command_not_found
    set -l command $argv
    jarvis "$command"
end
