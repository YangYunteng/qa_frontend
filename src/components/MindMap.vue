<template>
    <div class="tagCloud"
         ref="tagCloud"
          style="text-align:center; width: 700px;
            height: 500px; position: absolute"
    >
      <a v-for="(item,index) in tagList" :href="item.url" :style="'color:' + item.color + ';top: 0;left: 0;filter:none;'" :key="index">
        {{item.name}}
      </a>
      <v-text-field
        class="input"
        outlined
        dense
        placeholder="输入你的问题"
        append-icon="mdi-magnify"
        @blur="onUpdate()"
        v-model="input"
      >
      </v-text-field>
    </div>
</template>

<script>
export default {
  name: "MindMap",
  data() {
    return {
      tagList: [],
      radius: 225,
      dtr: Math.PI / 180,
      d: 450,
      mcList: [],
      active: false,
      lasta: 0,
      lastb: 1,
      distr: true,
      tspeed: 10,
      size: 400,
      mouseX: 0,
      mouseY: 0,
      howElliptical: 1,
      oList: null,
      oA: [],
      sa: 0,
      ca: 0,
      sb: 0,
      cb: 0,
      sc: 0,
      cc: 0,
      paper: null,
      input: ''
    }
  },
  methods: {
    // 生成随机数
    getRandomNum() {
      return Math.floor(Math.random() * (155 + 1) + 50);
    },
    // 三角函数角度计算
    sineCosine(a, b, c) {
      this.sa = Math.sin(a * this.dtr);
      this.ca = Math.cos(a * this.dtr);
      this.sb = Math.sin(b * this.dtr);
      this.cb = Math.cos(b * this.dtr);
      this.sc = Math.sin(c * this.dtr);
      this.cc = Math.cos(c * this.dtr);
    },
    // 设置初始定位
    positionAll() {
      this.$nextTick(() => {      // 注意: 所有的在onReady方法中执行的方法都需要$nextTick确保所有的标签都已经渲染
        let phi = 0;
        let theta = 0;
        let max = this.mcList.length;
        let aTmp = [];
        let oFragment = document.createDocumentFragment();
        // 随机排序
        for (let i = 0; i < this.oA.length; i++) {
          aTmp.push(this.oA[i]);
        }
        aTmp.sort(() => {
          return Math.random() < 0.5 ? 1 : -1;
        });
        for (let i = 0; i < aTmp.length; i++) {
          oFragment.appendChild(aTmp[i]);
        }
        this.oList.appendChild(oFragment);
        for (let i = 1; i < max + 1; i++) {
          if (this.distr) {
            phi = Math.acos(-1 + (2 * i - 1) / max);
            theta = Math.sqrt(max * Math.PI) * phi;
          } else {
            phi = Math.random() * (Math.PI);
            theta = Math.random() * (2 * Math.PI);
          }
          // 坐标变换
          this.mcList[i - 1].cx = this.radius * Math.cos(theta) * Math.sin(phi);
          this.mcList[i - 1].cy = this.radius * Math.sin(theta) * Math.sin(phi);
          this.mcList[i - 1].cz = this.radius * Math.cos(phi);
          this.oA[i - 1].style.left = this.mcList[i - 1].cx + this.oList.offsetWidth / 2 - this.mcList[i - 1].offsetWidth / 2 + 'px';
          this.oA[i - 1].style.top = this.mcList[i - 1].cy + this.oList.offsetHeight / 2 - this.mcList[i - 1].offsetHeight / 2 + 'px';
        }
      })
    },
    // 坐标更新 让标签动起来
    update() {
      this.$nextTick(() => {           // 注意: 所有的在onReady方法中执行的方法都需要$nextTick确保所有的标签都已经渲染
        let a;
        let b;
        if (this.active) {
          a = (-Math.min(Math.max(-this.mouseY, -this.size), this.size) / this.radius) * this.tspeed;
          b = (Math.min(Math.max(-this.mouseX, -this.size), this.size) / this.radius) * this.tspeed;
        } else {
          a = this.lasta * 0.98;
          b = this.lastb * 0.98;
        }
        this.lasta = a;
        this.lastb = b;
        if (Math.abs(a) <= 0.01 && Math.abs(b) <= 0.01) {
          return
        }
        let c = 0;
        this.sineCosine(a, b, c);
        for (let j = 0; j < this.mcList.length; j++) {
          let rx1 = this.mcList[j].cx;
          let ry1 = this.mcList[j].cy * this.ca + this.mcList[j].cz * (-this.sa);
          let rz1 = this.mcList[j].cy * this.sa + this.mcList[j].cz * this.ca;
          let rx2 = rx1 * this.cb + rz1 * this.sb;
          let ry2 = ry1;
          let rz2 = rx1 * (-this.sb) + rz1 * this.cb;
          let rx3 = rx2 * this.cc + ry2 * (-this.sc);
          let ry3 = rx2 * this.sc + ry2 * this.cc;
          let rz3 = rz2;
          this.mcList[j].cx = rx3;
          this.mcList[j].cy = ry3;
          this.mcList[j].cz = rz3;
          let per = this.d / (this.d + rz3);
          this.mcList[j].x = (this.howElliptical * rx3 * per) - (this.howElliptical * 2);
          this.mcList[j].y = ry3 * per;
          this.mcList[j].scale = per;
          this.mcList[j].alpha = per;
          this.mcList[j].alpha = (this.mcList[j].alpha - 0.6) * (10 / 6);
        }
        this.doPosition();
        this.depthSort();
      })
    },
    //
    doPosition() {
      this.$nextTick(() => {            // 注意: 所有的在onReady方法中执行的方法都需要$nextTick确保所有的标签都已经渲染
        let l = this.oList.offsetWidth / 2;
        let t = this.oList.offsetHeight / 2;
        for (let i = 0; i < this.mcList.length; i++) {
          this.oA[i].style.left = this.mcList[i].cx + l - this.mcList[i].offsetWidth / 2 + 'px';
          this.oA[i].style.top = this.mcList[i].cy + t - this.mcList[i].offsetHeight / 2 + 'px';
          this.oA[i].style.fontSize = Math.ceil(12 * this.mcList[i].scale / 2) + 8 + 'px';
          // this.oA[i].style.filter = "alpha(opacity=" + 100 * this.mcList[i].alpha + ")";
          this.oA[i].style.opacity = this.mcList[i].alpha * 0.5 + 0.5;
        }
      })
    },
    //
    depthSort() {
      this.$nextTick(() => {            // 注意: 所有的在onReady方法中执行的方法都需要$nextTick确保所有的标签都已经渲染
        let aTmp = [];
        for (let i = 0; i < this.oA.length; i++) {
          aTmp.push(this.oA[i]);
        }
        aTmp.sort(function (vItem1, vItem2) {
          if (vItem1.cz > vItem2.cz) {
            return -1;
          } else if (vItem1.cz < vItem2.cz) {
            return 1;
          } else {
            return 0;
          }
        });
        for (let i = 0; i < aTmp.length; i++) {
          aTmp[i].style.zIndex = i;
        }
      })
    },
    // 网络请求 拿到tagList
    async query() {
      await this.getData();
      await this.onReady();
    },
    // 生成标签云
    async onReady() {
      this.$nextTick(() => {
        this.oList = this.$refs.tagCloud;
        this.paper = document.querySelector(".tagCloud")
        this.oA = document.getElementsByTagName('a')
        let oTag = null;
        this.mcList=[];
        for (let i = 0; i < this.oA.length; i++) {
          oTag = {};
          oTag.offsetWidth = this.oA[i].offsetWidth;
          oTag.offsetHeight = this.oA[i].offsetHeight;
          this.mcList.push(oTag);
        }
        this.sineCosine(0, 0, 0);
        this.positionAll();
        this.paper.onmouseover = () => {
          this.active = true;
        }
        this.paper.onmouseout = () => {
          this.active = false;
        }
        this.paper.onmousemove = (event) => {
          let oEvent = window.event || event;

          this.mouseX = oEvent.clientX - (this.oList.offsetLeft + this.oList.offsetWidth / 2);
          this.mouseY = oEvent.clientY - (this.oList.offsetTop + this.oList.offsetHeight / 2);
          this.mouseX /= 30;
          this.mouseY /= 30;
        }
        setInterval(() => {
          this.update()
        }, 10);            // 定时器执行 不能写setInterval(this.update(), 30)
      })
    },
    async doNext() {
      this.$nextTick(() => {
        let temp = [];
        let data = this.$store.getters.getUserData;
        data.forEach((item, index) => {
          if (this.$store.state.token !== null) {
            temp.push({
              name: item.title,
              url: '/userHome/answerDetails/' + item.ID,
              color: "rgb(" + this.getRandomNum() + "," + this.getRandomNum() + "," + this.getRandomNum() + ")"
            });
          } else {
            temp.push({
              name: item.title,
              url: '/',
              color: "rgb(" + this.getRandomNum() + "," + this.getRandomNum() + "," + this.getRandomNum() + ")"
            });
          }
        });
        this.tagList = temp;
      })
    },
    async getData() {
      await this.$axios.get('/hot-list', {
        limit: 20
      }).then(async (resp) =>{
        if (resp.status === 200) {
          this.$store.commit('setUserData', resp.data.data);
          await this.doNext();
        }
      })
    },
    onUpdate() {
      this.query();
    }
  },
  created() {
    this.$nextTick(() => {
      this.query();
    })
  }
}

</script>

<style scoped>
.tagCloud {
  position: relative;
}
.tagCloud a {
  position: absolute;
  top: 0;
  left: 0;
  color: #fff;
  font-weight: bold;
  text-decoration: none;
  padding: 3px 6px;
}
.tagCloud a:hover {
  color: #FF0000;
  border: 2px solid white;
}
.input {
  width: 25%; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
}
.input:focus-within {
  width: 50%;
}
</style>
