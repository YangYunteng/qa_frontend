<template>
  <v-container>
    <v-card v-for="(item,index) in suggestions" :key="index" color="rgb(255,255,255,0.6)" class="mt-2" outlined
            min-height="50px">
      <v-row>
        <v-col cols="5">
          <b>建议提出者: {{ item.suggester_name }}: </b>
        </v-col>
        <v-spacer></v-spacer>
        <v-col>
          <v-tooltip bottom>
            <template v-slot:activator="{ on, attrs }">
              <v-icon color="primary" dark v-bind="attrs" v-on="on"
                      @click="openDialog(item,index)"
                      style="cursor: pointer">
                mdi-pencil
              </v-icon>
            </template>
            <span>修改</span>
          </v-tooltip>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px" class="justify-center">
        <v-col cols="11">
          <p v-html="item.content"></p>
        </v-col>
      </v-row>
      <v-row style="margin-top: -20px">
        <!--        <v-col cols="3">{{ getTime(item.UpdatedAt) }}</v-col>-->
        <v-col cols="3"><b>提交时间</b>: 2021-4-21 12:30:12</v-col>
      </v-row>
    </v-card>
    <div class="text-center">
      <v-pagination
        v-model="currPage"
        :length="PaginationLen"
        :total-visible="6"
        @input="querySuggestions"
      ></v-pagination>
    </div>

    <!-- 对回答和评论进行评论的Dialog -->
    <v-dialog transition="dialog-bottom-transition" v-model="isDialogOn" width="900px" persistent>
      <v-card>
        <v-toolbar
          color="primary"
          dark
        >评论
        </v-toolbar>
        <v-card-text class="mt-5">
          <v-textarea color="black" label="评论" v-model="comment"></v-textarea>
          <v-row class="justify-center">
            <v-col cols="12">
              <p>修改方式选择</p>
              <v-btn v-for="(item,index) in operations" :key="index"
                     class="mb-4 mr-4" elevation="2" :color=item.color depressed @click="chooseOperation(index)">
                {{ item.name }}
              </v-btn>
            </v-col>
          </v-row>
          <!-- 添加三元组 -->
          <v-card v-if="operations[0].on">
            <v-row class="justify-center">
              <v-col cols="3">
                <v-text-field v-model="add_spo_subject" label="主语" dense
                              ref="add_spo_subject" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="add_spo_predicate" label="谓词" dense
                              ref="add_spo_predicate" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="add_spo_object" label="宾语" dense
                              ref="add_spo_object" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将添加的三元组</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in add_spo_value" :key="index" close @click:close="deleteAddSPO(index)">
                  {{ item.subject }} {{ item.predicate }} {{ item.spo }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addAddSPO">添加</v-btn>
            </v-card-actions>

            <!-- 删除三元组 -->
          </v-card>
          <v-card v-if="operations[1].on">
            <v-row class="justify-center">
              <v-col cols="3">
                <v-text-field v-model="del_spo_subject" label="主语" dense
                              ref="del_spo_subject" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="del_spo_predicate" label="谓词" dense
                              ref="del_spo_predicate" outlined></v-text-field>
              </v-col>
              <v-col cols="3">
                <v-text-field v-model="del_spo_object" label="宾语" dense
                              ref="del_spo_object" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将删除的三元组</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in del_spo_value" :key="index" close @click:close="deleteDelSPO(index)">
                  {{ item.subject }} {{ item.predicate }} {{ item.spo }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addDelSPO">添加</v-btn>
            </v-card-actions>
          </v-card>
          <v-card v-if="operations[2].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="old_primary" label="原主名" dense
                              ref="old_primary" outlined></v-text-field>
              </v-col>
              <v-col cols="5">
                <v-text-field v-model="new_primary" label="新主名" dense
                              ref="new_primary" outlined></v-text-field>
              </v-col>
            </v-row>
          </v-card>
          <!-- 添加别名-->
          <v-card v-if="operations[3].on">
            <v-row class="justify-center">
              <v-col cols="5">
                <v-text-field v-model="add_aliases_primary" label="添加主名" dense
                              ref="add_aliases_primary" outlined></v-text-field>
              </v-col>

              <v-col cols="5">
                <v-text-field v-model="add_aliases_aliase" label="别名" dense
                              ref="add_aliases_aliase" outlined></v-text-field>
              </v-col>
            </v-row>
            <v-row style="margin-top: -20px">
              <v-col cols="2"><p>将添加的别名</p></v-col>
              <v-col cols="10">
                <v-chip v-for="(item,index) in del_spo_value" :key="index" close @click:close="deleteDelSPO(index)">
                  {{ item.subject }} {{ item.predicate }} {{ item.spo }}
                </v-chip>
              </v-col>
            </v-row>
            <v-card-actions class="justify-end">
              <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="addDelSPO">添加</v-btn>
            </v-card-actions>
          </v-card>
          <v-row v-if="operations[4].on">
            <p>4</p>
          </v-row>
          <v-row v-if="operations[5].on">
            <p>5</p>
          </v-row>
          <v-row v-if="operations[6].on">
            <p>6</p>
          </v-row>
        </v-card-text>
        <v-card-actions class="justify-end">
          <template v-for="(item,index) in operations">
            <v-btn v-if="item.on" class="mb-4 mr-4" elevation="2" color="primary" :key="index"
                   depressed @click="item.commit">提交{{ item.name }}
            </v-btn>
          </template>
          <v-btn class="mb-4 mr-4" elevation="2" color="primary" depressed @click="closeDialog">取消</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
export default {
  name: "Suggestions",
  props: ["suggestions"],
  data() {
    return {
      app: this.$root.$children[0],
      currPage: 1,
      PaginationLen: 1,
      pageSize: 5,
      comment: '',
      suggestion: {},
      suggestionID: 0,
      isDialogOn: false,
      isOperated: false,
      operations: [
        {name: '添加三元组', on: false, color: 'primary', commit: this.commit_spo_add},
        {name: '删除三元组', on: false, color: "error", commit: this.commit_spo_del},
        {name: '替换主名', on: false, color: 'primary', commit: this.commit_replace_primary},
        {name: '添加别名', on: false, color: 'warning', commit: this.commit_add_aliases},
        {name: '删除别名', on: false, color: 'error', commit: this.commit_del_aliases},
        {name: '增加实体类', on: false, color: 'primary', commit: this.commit_add_primary_aliases},
        {name: '删除实体类', on: false, color: 'error', commit: this.commit_del_primary_aliases}
      ],
      //添加三元组
      add_spo_subject: '',
      add_spo_predicate: '',
      add_spo_object: '',
      add_spo_value: [],
      //删除三元组
      del_spo_subject: '',
      del_spo_predicate: '',
      del_spo_object: '',
      del_spo_value: [],
      //替换主名
      old_primary: '',
      new_primary: '',
      //添加别名
      add_aliases_primary: '',
      add_aliases_aliase:'',
      add_aliases_arr: [],
      //删除别名
      del_aliases_primary: '',
      del_aliases_arr: [],
      //添加实体类
      add_object_primary: '',
      add_object_aliases: [],
      //删除实体类
      del_object_primary: '',
    }
  },
  mounted() {

  },
  methods: {
    chooseOperation: function (index) {
      for (let i = 0; i < this.operations.length; i++) {
        this.$set(this.operations[i], "on", false);
      }
      this.$set(this.operations[index], "on", true);
    },
    //添加三元组
    addAddSPO: function () {
      if (this.add_spo_object === '' || this.add_spo_subject === '' || this.add_spo_predicate === '')
        return;
      let value = {
        "subject": this.add_spo_subject,
        "predicate": this.add_spo_predicate,
        "spo": this.add_spo_object
      };
      this.add_spo_value.push(value);
      this.add_spo_object = '';
      this.add_spo_subject = '';
      this.add_spo_predicate = '';
    },

    deleteAddSPO: function (index) {
      this.add_spo_value.splice(index, 1);
    },

    commit_spo_add: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.add_spo_value.length === 0) {
        this.app.message('未添加三元组', 'warning');
        return;
      }
      let commit = {};
      commit.col_names = [
        "entity",
        "relation",
        "spo"
      ];
      commit.opt_type = "add_spo";
      commit.value = this.add_spo_value;
      let commands = [];
      commands.push(commit);
      console.log(commands);
      let path = '/adminServer/admin/commit';
      this.$axios.post(path,
        {
          "commands": commands,
          "comment": this.comment,
          "suggester_id": this.suggestion.suggester_id
        }).then(resp => {
        console.log(resp);
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
      console.log(this.add_spo_value);
    },
    openDialog: function (item, index) {
      this.suggestion = item;
      this.isDialogOn = true;
    },
    closeDialog: function () {
      this.isDialogOn = false;
    },
    //删除三元组
    addDelSPO: function () {
      if (this.del_spo_object === '' || this.del_spo_subject === '' || this.del_spo_predicate === '')
        return;
      let value = {
        "subject": this.del_spo_subject,
        "predicate": this.del_spo_predicate,
        "spo": this.del_spo_object
      };
      this.del_spo_value.push(value);
      this.del_spo_object = '';
      this.del_spo_subject = '';
      this.del_spo_predicate = '';
    },
    deleteDelSPO: function (index) {
      this.del_spo_value.splice(index, 1);
    },
    commit_spo_del: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.del_spo_value.length === 0) {
        this.app.message('未添加三元组', 'warning');
        return;
      }
      let commit = {};
      commit.col_names = [
        "entity",
        "relation",
        "spo"
      ];
      commit.opt_type = "del_spo";
      commit.value = this.del_spo_value;
      let commands = [];
      commands.push(commit);
      console.log(commands);
      let path = '/adminServer/admin/commit';
      this.$axios.post(path,
        {
          "commands": commands,
          "comment": this.comment,
          "suggester_id": this.suggestion.suggester_id
        }).then(resp => {
        console.log(resp);
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
      console.log(this.del_spo_value);
    },
    //替换主名
    commit_replace_primary: function () {
      if (this.comment === '') {
        this.app.message("评论不能为空", 'warning');
        return;
      }
      if (this.old_primary === '' || this.new_primary === '') {
        this.app.message("主名为填写完成", 'warning');
        return;
      }
      let commands = [];
      let command = {};
      command.col_names = [
        "entity"
      ];
      command.opt_type = "replace_primary";
      command.value = {
        "old": this.old_primary,
        "new": this.new_primary
      }
      let path = '/adminServer/admin/commit';
      this.$axios.post(path, {}).then(resp => {

      }).catch(() => {
        this.app.message('服务器在忙', 'red');
      })
    },


    commit_add_aliases: function () {

    },
    commit_del_aliases: function () {

    },
    commit_add_primary_aliases: function () {

    },
    commit_del_primary_aliases: function () {

    },
    getTime: function (date) {
      date = new Date(date);
      let res = '';
      res += date.getFullYear() + '-';
      res += this.timeComplement(date.getMonth() + 1, 2) + '-';
      res += this.timeComplement(date.getDate(), 2) + ' ';
      res += this.timeComplement(date.getHours(), 2) + ':';
      res += this.timeComplement(date.getMinutes(), 2) + ':';
      res += this.timeComplement(date.getSeconds(), 2);
      return res;
    },
    querySuggestions: function () {
      let path = '/adminServer/admin/suggestions';
      this.$axios.get(path, {params:{
        pageNum: 1,
        pageSize: 5,
      }}).then(resp => {
        console.log(resp);
      }).catch(() => {
        this.app.message("服务器在忙", 'red');
      })
    }
  }
}

</script>

<style scoped>

</style>
