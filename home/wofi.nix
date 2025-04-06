{
  programs.wofi = {
    enable = true;
    style = ''
      * {
        all: unset;
        font-family: "JetBrainsMono";
        font-size: 16px;
      }

      #window {
        background-color: #292a37;
        margin: auto;
        padding: 10px;
        border-radius: 12px;
        border: 5px solid #b072d1;
      }

      #input {
        padding: 0.5rem;
        margin: 1rem;
        border-radius: 10px;
        background-color: #303241;
      }

      /* search icon */
      #input:first-child > :nth-child(1) {
        min-height: 1.25rem;
        min-width: 1.25rem;
        margin-right: 2rem;
      }

      #outer-box {
        background-color: #292a37;
        border: 4px solid #44465c;
        border-radius: 12px;
      }

      #img {
        margin-right: 6px;
      }

      #entry {
        margin: 0.25rem 0.75rem 0.25rem 0.75rem;
        padding: 0.25rem 0.75rem 0.25rem 0.75rem;
        color: #9699b7;
        border-radius: 8px;
      }

      #entry:selected {
        background-color: #303241;
        color: #d9e0ee;
      }

      #text {
        margin: 2px;
      }
    '';
  };
}
