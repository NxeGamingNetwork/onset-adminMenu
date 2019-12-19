const players = document.querySelector('.players');
const template = document.querySelector('.template');

class Menu {
    constructor() {
        this.element = document.querySelector('.dropdown');
        this.primaryColor = '#d9d9d9';
    }
    isShowed() {
        return !this.element.hidden;
    }
    hide() {
        this.element.hidden = true;
    }
    show() {
        this.element.hidden = false;
    }
    highlightRow(node) {
        this.highlight = node;
        node.style.backgroundColor = this.primaryColor;
    }
    highlightRowDel() {
        this.highlight.style.backgroundColor = 'white';
    }
    getTarget() {
        return this.target;
    }
    setTarget(node) {
        this.target = node;
    }
    render() {
        const mouseCoords = {
            x: event.pageX,
            y: event.pageY
        };
        this.element.style.left = `${mouseCoords.x}px`;
        this.element.style.top = `${mouseCoords.y}px`;
        const menuCoords = this.element.getBoundingClientRect();
        const clientHeight = document.documentElement.clientHeight;
        if (menuCoords.top + this.element.offsetHeight > clientHeight) {
            this.element.style.top = parseInt(this.element.style.top) - this.element.offsetHeight + 'px';
        }
    }
}

const menu = new Menu();

function setValue(id, identifier, ping, firstname, name) {
    const clone = template.cloneNode(true);
    clone.hidden = false;

    clone.querySelector('.id').innerHTML = Base64Decode(id);
    clone.querySelector('.steamid').innerHTML = Base64Decode(identifier);
    clone.querySelector('.firstname').innerHTML = Base64Decode(firstname);
    clone.querySelector('.lastname').innerHTML = Base64Decode(name);
    clone.querySelector('.ping').innerHTML = Base64Decode(ping) + " ms";
    players.append(clone);
}

function deleteValue() {
    for(let i = 0; i < players.childElementCount; i++) {
        players.children[i].remove();
    }
}

players.addEventListener('click', () => {
    const target = event.target.parentNode;
    if (!target.classList.contains('row')) return;
    menu.show();
    menu.setTarget(target);
    menu.highlightRow(target);
    menu.render();
});

players.addEventListener('mousewheel', () => {
    if (menu.isShowed()) {
        menu.hide();
    }
});

const menuOptions = document.querySelector('.droplist');
const options = ['Kick', 'Ban', 'Spawn', 'NoClip', 'Teleport'];
options.forEach(key => {
    const li = document.createElement('li');
    li.className = 'droplist_items';
    li.innerHTML = key;
    menuOptions.append(li);
});

menuOptions.addEventListener('click', () => {
    const target = event.target;
    if (!target.classList.contains('droplist_items')) return;
    const row = menu.getTarget();
    const id = row.querySelector('.id').innerHTML;
    menu.highlightRowDel();

    sendData(target.innerHTML, id);
    $("body").css("display", "none");
    menu.hide();
});

function sendData(event, data) {
    CallEvent("on"+event, data);
    menu.hide();
}

function Base64Encode(str) {
    return btoa(encodeURIComponent(str).replace(/%([0-9A-F]{2})/g,
        function toSolidBytes(match, p1) {
            return String.fromCharCode('0x' + p1);
    }));
}

function Base64Decode(str) {
    return decodeURIComponent(atob(str).split('').map(function(c) {
        return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
}
